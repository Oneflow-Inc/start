open HeadlessUI

module Hero = {
  @react.component
  let make = (~children) => <div> <div className=""> children </div> </div>
}

module Variant = {
  type build = Stable | Nightly
  type platform = CUDA(string) | CPU | CUDA_XLA(string)
  @deriving(accessors)
  type t = {build: build, platform: platform}
  module Option = {
    @react.component
    let make = (~name, ~hidden=false) =>
      <Tab
        key={name}
        className={({selected}) =>
          Js.Array.joinWith(
            " ",
            [
              `w-full py-2.5 text-sm leading-5 font-medium rounded-lg`,
              `focus:outline-none focus:ring-2 ring-offset-2 ring-offset-blue-400 ring-white ring-opacity-60`,
              hidden ? "hidden" : "",
              selected
                ? `bg-white shadow text-blue-700 text-opacity-80`
                : `text-blue-100 hover:bg-white hover:bg-opacity-10 hover:text-white`,
            ],
          )}>
        {_ => React.string(name)}
      </Tab>
  }
}
let platformPlusName = (p: Variant.platform) => {
  switch p {
  | Variant.CUDA(ver) => "cu" ++ Js.String.replace(".", "", ver)
  | Variant.CUDA_XLA(ver) => "cu" ++ Js.String.replace(".", "", ver) ++ ".xla"
  | Variant.CPU => "cpu"
  }
}

module Pip = {
  module Panel = {
    @react.component
    let make = (~cmd) =>
      <Tab.Panel
        key=cmd
        className={_ =>
          Js.Array.joinWith(
            " ",
            [
              `bg-white rounded-xl p-3`,
              `focus:outline-none focus:ring-2 ring-offset-2 ring-offset-blue-400 ring-white ring-opacity-60`,
            ],
          )}>
        {_ => React.string(cmd)}
      </Tab.Panel>
  }
}

let pipInstallCommnad = (selected: Variant.t) => {
  Js.Array.joinWith(
    " ",
    [
      "python3 -m pip install -f",
      switch selected.build {
      | Variant.Stable =>
        "https://release.oneflow.info oneflow==0.4.0+" ++ platformPlusName(selected.platform)
      | Variant.Nightly =>
        "https://staging.oneflow.info/branch/master/" ++
        platformPlusName(selected.platform) ++ " oneflow"
      },
      "",
    ],
  )
}

type action =
  | SelectBuild(string)
  | SelectPlatform(string)
  | SelectCudaVersion(string)

type state = {selected: Variant.t}

let reducer = (state, action) =>
  switch action {
  | SelectBuild(b) =>
    let build = switch b {
    | "Stable" => Variant.Stable
    | "Nightly" => Variant.Nightly
    | _ => Variant.Stable
    }
    {selected: {...state.selected, build: build}}
  | SelectPlatform(p) =>
    let platform = switch p {
    | "CUDA" => Variant.CUDA("10.2")
    | "CUDA_XLA" => Variant.CUDA_XLA("10.1")
    | _ => Variant.CPU
    }
    {selected: {...state.selected, platform: platform}}
  | SelectCudaVersion(v) =>
    switch state.selected.platform {
    | CUDA(_) => {selected: {...state.selected, platform: CUDA(v)}}
    | CUDA_XLA(_) => {selected: {...state.selected, platform: CUDA_XLA(v)}}
    | _ => state
    }
  }

let default = () => {
  let (state, dispatch) = React.useReducer(
    reducer,
    {
      selected: {
        build: Variant.Stable,
        platform: Variant.CUDA("10.2"),
      },
    },
  )
  let builds = ["Stable", "Nightly"]
  let platforms = ["CUDA", "CUDA_XLA", "CPU"]
  let cudaVersions = ["10.0", "10.1", "10.2", "11.0", "11.1", "11.2"]
  let xlaCudaVersions = ["10.0", "10.1", "10.2", "11.0", "11.1"]
  let defaultIndexOfCudaVersion = (state: state) =>
    switch state.selected.platform {
    | Variant.CUDA(_) => Js.Array.indexOf("10.2", cudaVersions)
    | Variant.CUDA_XLA(_) => Js.Array.indexOf("10.1", xlaCudaVersions)
    | Variant.CPU => 0
    }
  let availableCudaVersions = (state: state) =>
    switch state.selected.platform {
    | Variant.CUDA(_) => cudaVersions
    | Variant.CUDA_XLA(_) => xlaCudaVersions
    | Variant.CPU => []
    }
  <Hero>
    <div
      className=`rounded-xl overflow-hidden bg-gradient-to-r from-sky-400 to-blue-600 flex flex-col items-center justify-center w-full`>
      <div className="w-full max-w-md px-2 py-16 sm:px-0">
        <Tab.Group onChange={index => dispatch(SelectBuild(builds[index]))}>
          <Tab.List className="flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl">
            {_ =>
              builds
              |> Js.Array.map(b => {
                <Variant.Option key=b name=b />
              })
              |> React.array}
          </Tab.List>
        </Tab.Group>
        <Tab.Group onChange={index => dispatch(SelectPlatform(platforms[index]))}>
          <Tab.List className="my-1 flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl">
            {_ =>
              platforms
              |> Js.Array.map(v => {
                <Variant.Option key=v name=v />
              })
              |> React.array}
          </Tab.List>
        </Tab.Group>
        <Tab.Group
          key={availableCudaVersions(state) |> Js.Array.length |> string_of_int}
          defaultIndex={defaultIndexOfCudaVersion(state)}
          onChange={index => dispatch(SelectCudaVersion(cudaVersions[index]))}>
          <Tab.List
            key={availableCudaVersions(state) |> Js.Array.length |> string_of_int}
            className={"my-1 flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl" ++
            switch state.selected.platform {
            | Variant.CPU => " hidden"
            | _ => ""
            }}>
            {_ =>
              cudaVersions
              |> Js.Array.map(v => {
                <Variant.Option
                  name=v
                  key=v
                  hidden={switch (state.selected.platform, v) {
                  | (Variant.CUDA_XLA(_), "11.2") => true
                  | _ => false
                  }}
                />
              })
              |> React.array}
          </Tab.List>
          <Tab.Panels className="mt-2">
            {_ =>
              cudaVersions
              |> Js.Array.mapi((v, _) =>
                <Pip.Panel key=v cmd={pipInstallCommnad(state.selected)} />
              )
              |> React.array}
          </Tab.Panels>
        </Tab.Group>
      </div>
    </div>
  </Hero>
}
