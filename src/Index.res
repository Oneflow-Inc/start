module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>
}

open HeadlessUI

module Hero = {
  @react.component
  let make = (~children) => <div> <div className=""> children </div> </div>
}

let allCudaVersions = [`10.0`, `10.1`, `10.2`, `11.0`, `11.1`, `11.2`]
let xlaCudaVersions = [`10.0`, `10.1`, `10.2`, `11.0`, `11.1`]

let platforms = [`CUDA`, `CPU`, `CUDA-XLA`]
module Variant = {
  type build = Stable | Nightly
  type platform = CUDA(string) | CPU | CUDA_XLA(string)
  @deriving(accessors)
  type t = {build: build, platform: platform}
  module Option = {
    @react.component
    let make = (~name) =>
      <Tab
        key={name}
        className={({selected}) =>
          Js.Array.joinWith(
            " ",
            [
              `w-full py-2.5 text-sm leading-5 font-medium rounded-lg`,
              `focus:outline-none focus:ring-2 ring-offset-2 ring-offset-blue-400 ring-white ring-opacity-60`,
              selected
                ? `bg-white shadow text-blue-700 text-opacity-80`
                : `text-blue-100 hover:bg-white hover:bg-opacity-10 hover:text-white`,
            ],
          )}>
        {({selected}) => React.string(name)}
      </Tab>
  }
}
let builds = [Variant.Stable, Variant.Nightly]
let pipInstallCommnad = (selected: Variant.t) => {
  Js.Array.joinWith(
    " ",
    [
      "python3 -m pip install oneflow -f",
      switch selected.build {
      | Variant.Stable => "https://release.oneflow.info"
      | Variant.Nightly => "https://staging.oneflow.info/branch/master/cu101"
      },
      "",
    ],
  )
}

let default = () => {
  let (state, setState) = React.useState(() => {
    let s: Variant.t = {
      build: Variant.Stable,
      platform: Variant.CUDA("10.2"),
    }
    s
  })
  let availableCUDAVersions = (state: Variant.t) =>
    switch state.platform {
    | Variant.CUDA(_) => ["10.0", "10.1", "10.2", "11.0", "11.1", "11.2"]
    | Variant.CUDA_XLA(_) => ["10.0", "10.1", "10.2", "11.0", "11.1"]
    | Variant.CPU => []
    }
  let updatePlatfrom = (currentPlatform: Variant.platform, displayName: string) =>
    switch displayName {
    | "CUDA" =>
      switch currentPlatform {
      | Variant.CUDA_XLA(ver) => Variant.CUDA(ver)
      | _ => Variant.CUDA("10.2")
      }
    | "CUDA-XLA" =>
      switch currentPlatform {
      | Variant.CUDA(`11.2`) => Variant.CUDA_XLA("10.1")
      | Variant.CUDA(ver) => Variant.CUDA_XLA(ver)
      | _ => Variant.CUDA_XLA("10.1")
      }
    | "CPU" => Variant.CPU
    | _ => Variant.CUDA("10.2")
    }

  <Hero>
    <div
      className=`rounded-xl overflow-hidden bg-gradient-to-r from-sky-400 to-blue-600 flex flex-col items-center justify-center w-full`>
      <div className="w-full max-w-md px-2 py-16 sm:px-0">
        <Tab.Group onChange={index => setState(s => {...s, build: builds[index]})}>
          <Tab.List className="flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl">
            {({selectedIndex}) =>
              builds
              |> Js.Array.map(b => {
                let s = switch b {
                | Variant.Stable => "Stable"
                | Variant.Nightly => "Nightly"
                }
                <Variant.Option name=s />
              })
              |> React.array}
          </Tab.List>
        </Tab.Group>
        <Tab.Group
          onChange={index =>
            setState(s => {...s, platform: updatePlatfrom(s.platform, platforms[index])})}>
          <Tab.List className="my-1 flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl">
            {({selectedIndex}) =>
              platforms
              |> Js.Array.map((category: string) => <Variant.Option name=category />)
              |> React.array}
          </Tab.List>
        </Tab.Group>
        <Tab.Group>
          <Tab.List className="flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl">
            {({selectedIndex}) =>
              availableCUDAVersions(state)
              |> Js.Array.map((category: string) => <Variant.Option name=category />)
              |> React.array}
          </Tab.List>
          <Tab.Panels className="mt-2">
            {_ =>
              availableCUDAVersions(state)
              |> Js.Array.mapi((v, idx) =>
                <Tab.Panel
                  key=v
                  className={({selected}) =>
                    Js.Array.joinWith(
                      " ",
                      [
                        `bg-white rounded-xl p-3`,
                        `focus:outline-none focus:ring-2 ring-offset-2 ring-offset-blue-400 ring-white ring-opacity-60`,
                      ],
                    )}>
                  {_ => React.string(pipInstallCommnad(state))}
                </Tab.Panel>
              )
              |> React.array}
          </Tab.Panels>
        </Tab.Group>
      </div>
    </div>
  </Hero>
}
