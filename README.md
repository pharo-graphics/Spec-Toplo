# Spec-Toplo

[![License](https://img.shields.io/github/license/pharo-graphics/Spec-Toplo.svg)](./LICENSE)
[![Tests](https://github.com/pharo-graphics/Spec-Toplo/actions/workflows/ci.yml/badge.svg)](https://github.com/pharo-graphics/Spec-Toplo/actions/workflows/ci.yml)

[Toplo](https://github.com/plantec/Toplo) backend for [Spec](https://github.com/pharo-spec/Spec).

Toplo is a widget library on top of [Bloc](https://github.com/pharo-graphics/Bloc).

Spec is a [Pharo](https://pharo.org/) library for describing user interfaces. You describe a UI by composing the "presenters" and by connecting them via block closures.

More concretely, a Spec UI is a tree of `SpPresenter`, that is opened in the context of an application (`SpApplication`) that, among others, indicates what is the backend.

Our backend (`SpToploBackend`) provides the adapters (hierarchy of `SpToploAdapter`) to make the `Toplo` widgets to act as the tree of presenters describe.

Other Spec backends are:
- Morphic (the default)
- [GTK](https://github.com/pharo-spec/Spec-Gtk)


## Install

The project can be loaded as usual via Metacello, using the `BaselineOfSpecToplo` specification. To copy/paste a loading script, see [this wiki page](../../wiki/Install).


## Running Tests

When developing `Spec-Toplo`, you should run **two sets of test suites**:

1. **Toplo-specific backend tests:** Packages matching `Spec-Toplo*-Tests` (`Spec-Toplo-Tests`, `Spec-Toplo-Backend-Tests`), which test Toplo adapters, widgets, and synchronization directly.
2. **Spec2 generic contract tests:** Package `Spec2-Backend-Tests` (`SpButtonAdapterTest`, `SpLabelAdapterTest`, `SpBoxLayoutAdapterTest`, etc.). These verify that `SpToploBackend` conforms to the upstream Spec2 contract.

```smalltalk
"Run both suites in DrTests or via Smalltalk script:"
(TestRunner runPackages: {
	'Spec-Toplo-Tests'.
	'Spec-Toplo-Backend-Tests'.
	'Spec2-Backend-Tests' })
```

### Configuring Host Backends (Headless vs Interactive)

Generic Spec tests are parameterized by Bloc host. By default, they run exclusively on the fast **Headless host** to avoid stealing focus or opening OS windows during development.

You can toggle whether tests run headless-only or across all available hosts (Headless, SDL3, SDL2, Morphic) in two ways:

#### 1. Via System Settings UI
Open **Settings Browser** (`World Menu > System > Settings`), navigate to:
```
Bloc > Hosts for parameterized tests
```
- **Headless host only (Fast)** *(Default)*: Runs tests headlessly in background.
- **All available hosts**: Tests the matrix against all registered hosts (including real OS windows).

<img width="909" height="497" alt="ParameterizedTests" src="https://github.com/user-attachments/assets/10b2016e-9a97-4fcd-90c1-0a5dd31cbc39" />

#### 2. Programmatically
```smalltalk
"Run fast on headless host only (default)"
BlParameterizedHostTest testHostsMode: #headlessOnly.

"Run full matrix across Headless, SDL2, and Morphic"
BlParameterizedHostTest testHostsMode: #allAvailable.
```


## Debugging

### Running with Toplo vs. Morphic

To run or debug a presenter with the Toplo backend, assign an application configured with `#Toplo`:

```smalltalk
app := StPharoApplication new.
app useBackend: #Toplo.

presenter := MyPresenter new.
presenter application: app.
presenter open.
```

> **Tip:** Omitting `presenter application: app` opens the presenter with the default Morphic backend, enabling side-by-side visual and behavioral comparisons.

### Navigating Adapters, Widgets, and Constraints

When diagnosing layout, event, or styling issues, navigate between Spec presenters and Toplo widgets:

```smalltalk
"Retrieve the Toplo adapter from the presenter"
adapter := presenter adapter. "Answers an SpToplo*Adapter"

"Retrieve the root BlElement / To* widget"
widget := presenter adapter widget.

"Inspect layout constraint resizers vs. actual computed geometry bounds"
widget constraints horizontal resizer. "e.g. Match parent, Exact 200, Fit content"
widget bounds asRectangle.
```

To quickly close temporary spaces opened during interactive debugging in the Playground, evaluate `Bloc closeSpaces`.

### Bloc Foundation Documentation

For the underlying Bloc concurrency model, testing, and layout mechanics, refer to the documentation in the [Bloc repository](https://github.com/pharo-graphics/Bloc):
- [Concurrency and Synchronization](https://github.com/pharo-graphics/Bloc/blob/dev/doc/2-ConcurrencyAndSynchronization.md): The host pulse loop, `#settle`, `#deferAndSettle:`, and pulse process safety.
- [Testing and Simulating Interactions](https://github.com/pharo-graphics/Bloc/blob/dev/doc/TestingInteractions.md): Programmatic event simulation with `BlEventSimulator`.
- [Layout and Constraints](https://github.com/pharo-graphics/Bloc/blob/dev/doc/LayoutAndConstraints.md): Measurement passes, resizers, and layout events.


## Branches & Contributions

We describe our contribution workflow & branch name convention in [this wiki page](../../wiki/Branches-and-versions).


## License

This code is licensed under the [MIT license](./LICENSE).
