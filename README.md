# Spec-Toplo

[![License](https://img.shields.io/github/license/pharo-graphics/Spec-Toplo.svg)](./LICENSE)
[![Tests](https://github.com/pharo-graphics/Spec-Toplo/actions/workflows/tests.yml/badge.svg)](https://github.com/pharo-graphics/Spec-Toplo/actions/workflows/tests.yml)

[Toplo](https://github.com/plantec/Toplo) backend for [Spec](https://github.com/pharo-spec/Spec). 

Toplo is a widget library on top of [Bloc](https://github.com/pharo-graphics/Bloc).

Spec is a [Pharo](https://pharo.org/) library for describing user interfaces. You describe a UI by composing the "presenters" and by connecting them via block closures.

More concretely, a Spec UI is a tree of `SpPresenter`, that is opened in the context of an application (`SpApplication`) that, among others, indicates what is the backend.

Our backend (`SpToploBackend`) provides the adapters (hierarchy of `SpToploAdapter`) to make the `Toplo` widgets to act as the tree of presenters describe.

Other Spec backends are:
- Morphic (the default)
- [GTK](https://github.com/pharo-spec/Spec-Gtk)

This backend is in active development. The following presenters and layouts are supported (but not completely):

* Label
* Text, Code and TextInput
* List, DropList
* Button
* Button bar
* Checkbox
* Radio button
* Toggle button
* Menu bar
* Paned and Box layouts
* Window and Dialog


## Install

The project can be loaded as usual via Metacello, using the `BaselineOfSpecToplo` specification. To copy/paste a loading script, see [this wiki page](../../wiki/Install).


## Branches & Contributions

We describe our contribution workflow & branch name convention in [this wiki page](../../wiki/Branches-and-versions).


## License

This code is licensed under the [MIT license](./LICENSE).
