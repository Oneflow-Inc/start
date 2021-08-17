module Menu = {
  type state = {@as("open") open_: bool}

  @module("@headlessui/react") @react.component
  external make: (
    ~_as: [#div]=?,
    ~className: string=?,
    ~children: state => React.element,
  ) => React.element = "Menu"

  module Button = {
    @module("@headlessui/react") @scope("Menu") @react.component
    external make: (~className: string=?, ~children: React.element) => React.element = "Button"
  }

  module Items = {
    @module("@headlessui/react") @scope("Menu") @react.component
    external make: (
      ~static: bool=?,
      ~children: React.element,
      ~className: string=?,
    ) => React.element = "Items"
  }

  module Item = {
    type state = {active: bool}
    @module("@headlessui/react") @scope("Menu") @react.component
    external make: (
      ~children: state => React.element,
      ~_as: string=?,
      ~disabled: bool=?,
      ~className: string=?,
    ) => React.element = "Item"
  }
}

module Listbox = {
  type state = {@as("open") open_: bool}

  @module("@headlessui/react") @react.component
  external make: (
    ~value: 'state=?,
    ~onChange: 'state => unit=?,
    ~className: string=?,
    ~children: state => React.element,
  ) => React.element = "Listbox"

  module Button = {
    @module("@headlessui/react") @scope("Listbox") @react.component
    external make: (~className: string=?, ~children: React.element=?) => React.element = "Button"
  }

  module Options = {
    @module("@headlessui/react") @scope("Listbox") @react.component
    external make: (
      ~static: bool=?,
      ~className: string=?,
      ~children: React.element,
    ) => React.element = "Options"
  }

  module Option = {
    type state = {selected: bool, active: bool}
    @module("@headlessui/react") @scope("Listbox") @react.component
    external make: (
      ~children: state => React.element,
      ~value: 'item,
      ~disabled: bool=?,
    ) => React.element = "Option"
  }
}

module Transition = {
  @module("@headlessui/react") @react.component
  external make: (
    ~appear: bool=?,
    ~show: bool,
    ~enter: string=?,
    ~enterFrom: string=?,
    ~enterTo: string=?,
    ~leave: string=?,
    ~leaveFrom: string=?,
    ~leaveTo: string=?,
    ~children: React.element,
  ) => React.element = "Transition"
}

module Tab = {
  type state = {selected: bool}
  @module("@headlessui/react") @react.component
  external make: (
    ~_as: [#div]=?,
    ~className: state => string,
    ~children: state => React.element,
  ) => React.element = "Tab"

  module Group = {
    @module("@headlessui/react") @scope("Tab") @react.component
    external make: (
      ~static: bool=?,
      ~children: React.element,
      ~className: string=?,
    ) => React.element = "Group"
  }

  module List = {
    type state = {selectedIndex: int}
    @module("@headlessui/react") @scope("Tab") @react.component
    external make: (
      ~_as: [#div]=?,
      ~children: state => React.element,
      ~className: string=?,
    ) => React.element = "List"
  }
}
