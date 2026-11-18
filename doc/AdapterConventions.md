# Spec-Toplo Adapter Architecture & Conventions

Adapters in Spec-Toplo bridge the declarative, high-level Spec presenter tree (`model`) to the imperative Bloc/Toplo element tree (`widget`).

To maintain consistency across the codebase, prevent memory leaks, and avoid event cycles, all adapters follow the architecture and conventions detailed below.

---

## 1. Direct Instance Variable Access (`model` & `widget`)

- **Direct instvars in adapters**: Subclasses of `SpToploAdapter` inherit `model` and `widget` from `SpAbstractAdapter`. Always access `model` and `widget` directly rather than sending accessor messages (`self presenter`, `self model`, or `self widget`).
- **Eliminate `self widgetDo:` overhead**: After `#adapt:`, `widget` is guaranteed to exist. Use direct `widget` access instead of `self widgetDo: [ :w | ... ]`, avoiding unnecessary block allocations.
- **Traits Exception**: In Pharo, Traits cannot declare slots. Traits (e.g., `SpToploTWithContextMenu`, `SpToploTTreeHelper`) **must** use accessor sends (`self model` and `self widget`).

---

## 2. Adapter Lifecycle & Initialization Pipeline

The adaptation lifecycle is strictly sequenced in `SpToploAdapter >> #adaptToploWidget`:

```smalltalk
SpToploAdapter >> adaptToploWidget [
	"Initialize and bind the widget to the model"

	self
		updateLayout;
		updateAll;
		addShortcuts;
		subscribeToPresenter;
		subscribeToWidget
]
```

Each stage has a single, well-defined responsibility:

| Hook | Responsibility | Convention / Contract |
| :--- | :--- | :--- |
| `buildWidget` | Instantiates and does initial Toplo widget setup. | Protocol `#factory`. Return the newly built widget. |
| `updateLayout` | Configures layout constraints. | Defaults to `widget matchParent`. Overridden only for windows, dialogs, or layouts. |
| `updateAll` | Pushes all current presenter state to the widget. | **Always send `super updateAll` first**, then cascade property updaters: `self updateLabel; updateIcon; updateState`. |
| `addShortcuts` | Binds key combinations from presenter actions to the widget. | Handled automatically in base `SpToploAdapter`. |
| `subscribeToPresenter` | Listens to model announcements (`when<Prop>ChangedDo:`). | **Always send `super subscribeToPresenter` first**. Each callback delegates directly to `self update<Prop>`. |
| `subscribeToWidget` | Listens to Toplo widget events to update `model`. | **Always send `super subscribeToWidget` first**. Must use lifecycle-tracked subscription helpers. |

---

## 3. Single Source of Truth for State Synchronization (`update<Property>`)

- Every synchronized property has a dedicated updater method named `update<Property>` (e.g., `updateLabel`, `updateIcon`, `updateState`, `updateSelection`, `updateItems`).
- Place all updater methods in the `'updating widget'` protocol.
- **Zero Duplication**:
  - `updateAll` calls `self update<Property>`.
  - `subscribeToPresenter` callbacks call `[ self update<Property> ]`.
  - Never duplicate the property translation logic between initial setup and live updates.

---

## 4. Cycle & Echo Prevention (Feedback Loops)

Because adapters synchronize bi-directionally between `model` and `widget`, feedback loops must be actively guarded against:

1. **Equality Guards in Updaters**: Check whether the widget already reflects the new value before applying mutations:
   ```smalltalk
   SpToploAbstractTextAdapter >> updateText [

   	widget text asString = model text ifTrue: [ ^ self ].
   	widget text: model text
   ]
   ```
2. **Event Suppression / Suspension**: For widgets firing continuous or echoed events (such as Album text editing or tree selection), suspend handlers during model updates:
   ```smalltalk
   eventHandler suspendEventHandlingDuring: [
   	model text: aBlText asString ]
   ```

---

## 5. Memory Leak Prevention & Lifecycle Teardown

Adapters are short-lived compared to presenters or long-lived spaces. Proper teardown is mandatory:

- **Tracked Widget Event Handlers**: Never attach event handlers to widgets with raw `addEventHandler:` unless you manually manage their lifecycle. Instead, use:
  ```smalltalk
  self subscribeToWidgetEvent: aBlEventClass do: aBlock
  "or for child elements / spaces:"
  self subscribeToWidgetEvent: aBlEventClass on: anElement do: aBlock
  ```
  This registers handlers in `widgetSubscriptions` (`IdentityDictionary`), ensuring `unsubscribeFromWidget` unregisters all handlers automatically upon teardown.
- **Tracked Composite Presenters**: When an adapter creates widgets for child presenters (e.g., `SpToploMenuLikeAdapter` instantiating items from `SpMenuItemPresenter`s), track each child presenter in `presenterSubscriptions`:
  ```smalltalk
  presenterSubscriptions add: item.
  ```
  This ensures `unsubscribeFromPresenters` unhooks all child presenters cleanly when the menu closes or updates.

---

## 6. Spec Metadata Storage via `userData`

When an adapter needs to associate metadata with a widget (for testing, introspection, or drag-and-drop transfers) without subclassing or polluting Toplo element classes, use the `#spec<Name>` key convention on `userData`:

```smalltalk
widget userData at: #specIcon put: model icon.
widget userData at: #specHelpText put: model help.
widget userData at: #specPlaceholder put: model placeholder.
widget userData at: #specModel put: model.
```

---

## 7. Deferred Space Execution

Bloc geometry, bounds, and layout measurements are computed during the space pulse phase.
- If an adapter needs to position an element relative to another element or space (e.g., window centering, popover placement), use `self defer: aBlock` (or `self backend defer: aBlock`).
- This enqueues a `BlTaskAction` to be evaluated at the beginning of the next pulse, guaranteeing valid geometry.

---

## 8. Testing & Interaction Emulation

- Adapters provide user action simulation under the `'emulating'` protocol (e.g., `clicked`, `sendRightClickEvent`).
- Always use Bloc's event simulator (`widget eventSimulator click`, `widget eventSimulator secondaryClick`), which guarantees tests behave identically in both headless and OS window environments.

---

## 9. Naming & Class Registration

- **Class naming**: `SpToplo<PresenterNameWithoutSp>Adapter` (e.g., `SpButtonPresenter` $\rightarrow$ `SpToploButtonAdapter`).
- **Adapting name**: `SpToploAdapter class >> #adaptingName` strips the `'SpToplo'` prefix by default. Override it only when the presenter name does not follow standard conventions.
