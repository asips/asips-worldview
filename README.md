This project demonstrates how the Atmosphere SIPS team builds their custom instance of [NASA Worldview](https://github.com/nasa-gibs/worldview).
To try yourself:
```
$ docker build -f Dockerfile -t asips-worldview --target app .
$ docker run --rm asips-worldview:latest
```
Your instance should now be available at http://localhost:8080/.

We make use of the python package [worldview-config](https://github.com/asips/worldview-config) to simplify
staying in-sync with the main GIBS instance and applying our own layer configuration.  As a result only a few static files
(e.g. our branding) need to maintained in this repo:
```
$ tree
.
├── config
│   └── active
│       ├── common
│       │   ├── brand
│       │   │   └── images
│       │   │       ├── favicon.ico
│       │   │       ├── wv-logo-mobile.png
│       │   │       ├── wv-logo-mobile.svg
│       │   │       ├── wv-logo.png
│       │   │       ├── wv-logo.svg
│       │   │       └── wv-logo-w-shadow.svg
│       │   ├── brand.json
│       │   ├── colormaps
│       │   │   ├── Clear_Sky_Confidence.colormap.xml
│       │   │   └── Cloud_Effective_Radius.colormap.xml
│       │   ├── config
│       │   │   └── wv.json
│       │   │       └── defaults.json
│       │   └── features.json
│       └── release
│           └── config
│               └── wv.json
│                   └── sources.json
├── Dockerfile
├── layer_config.json
└── README.md
```


`layer_config.json` contains a couple layers for demonstration purposes - in practice we maintain a database
containing a table with all our layers and have a script for exporting to a JSON file.