# Experiment repositoy for stx build system 2.0

## How to build a package?

```
    bash setup.sh
```

This will clone [autodeb tool](https://github.com/VictorRodriguez/autodeb)

Example of how to build a package:

```
    make package PKG=fault/fm-common DISTRO=ubuntu
```

clean with :

```
    make clean PKG=fault/fm-common DISTRO=ubuntu
```

debs will be in fault/fm-common in this case
