# Spec-Toplo

[![License](https://img.shields.io/github/license/pharo-graphics/Spec-Toplo.svg)](./LICENSE)
[![Tests](https://github.com/pharo-graphics/Spec-Toplo/actions/workflows/test.yml/badge.svg)](https://github.com/pharo-graphics/Spec-Toplo/actions/workflows/test.yml)

[Toplo](https://github.com/plantec/Toplo) backend for [Spec](https://github.com/pharo-spec/Spec). 

Toplo is a widget library on top of [Bloc](https://github.com/pharo-graphics/Bloc).

Spec is a [Pharo](https://pharo.org/) library for describing user interfaces. You describe a UI by composing the "presenters" and by connecting them via block closures.

More concretely, a Spec UI is a tree of `SpPresenter`, that is opened in the context of an application (`SpApplication`) that, among others, indicates what is the backend.

Our backend (`SpToploBackend`) provides the adapters (hierarchy of `SpToploAdapter`) to make the `Toplo` widgets to act as the tree of presenters describe.

Other Spec backends are:
- Morphic (the default)
- [GTK](https://github.com/pharo-spec/Spec-Gtk)


## Installation

Evaluate the following script on [Pharo 11 or 12](https://pharo.org/download):

```smalltalk
Metacello new
	baseline: 'SpecToplo';
	repository: 'github://pharo-graphics/Spec-Toplo/src';
	load
```


## License

This code is licensed under the [MIT license](./LICENSE).
