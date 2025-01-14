ARG NODE_VERSION=20.18.0
FROM node:${NODE_VERSION} as build_base
# This stage retrieves the requested version of worldview
# and builds out config for the GIBS layers
# by querying their GetCapabilities endpoint
WORKDIR /code

ARG WORLDVIEW_VERSION=4.55.0
RUN git clone -b v${WORLDVIEW_VERSION} --single-branch --depth 1 \
    https://github.com/nasa-gibs/worldview.git .

RUN npm ci
RUN npm run clean
RUN npm run getcapabilities

FROM python:3.11 as config

RUN pip install worldview-config==0.2.1

# Bring in the static config stored in this repo
COPY config/active /new_config

# Render the templates using the layer config file
COPY layer_config.json /tmp/layer_config.json
RUN worldview_config render /tmp/layer_config.json --target /new_config

# Merge the ASIPS config into the GIBS config
COPY --from=build_base /code/config/default /config
RUN worldview_config merge /new_config /config

FROM build_base as build
COPY --from=config /config /code/config/active
WORKDIR /code

RUN npm run build:config
RUN npm run build:prod
RUN node ./tasks/util/dist.js
RUN rm -rf dist

FROM nginxinc/nginx-unprivileged as app
COPY --from=build /code/build/worldview/ /usr/share/nginx/html/
