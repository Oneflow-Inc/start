module P = {
  @react.component
  let make = (~children) => <p className="mb-2"> children </p>
}

open HeadlessUI

type category = {
  id: int,
  title: string,
  date: string,
  commentCount: int,
  shareCount: int,
}

module Hero = {
  @react.component
  let make = (~children) => <div> <div className=""> children </div> </div>
}

let allCudaVersions = [`10.0`, `10.1`, `10.2`, `11.0`, `11.1`, `11.2`]
let xlaCudaVersions = [`10.0`, `10.1`, `10.2`, `11.0`, `11.1`]
let builds = [`Stable`, `Nightly`]
let platforms = [`CUDA`, `CPU`, `CUDA-XLA`]
module Variant = {
  type build = Stable | Nightly
  type cuda_version = CUDA_10_0 | CUDA_10_1 | CUDA_10_2 | CUDA_11_0 | CUDA_11_1 | CUDA_11_2
  type xla_cuda_version = CUDA_10_0 | CUDA_10_1 | CUDA_10_2 | CUDA_11_0 | CUDA_11_1
  type platform =
    CUDA({cuda_version: cuda_version}) | CPU | CUDA_XLA({cuda_version: xla_cuda_version})
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

let default = () => {
  let (categories, setState) = React.useState(() =>
    Js.Dict.fromArray([
      (
        "CUDA",
        [
          {
            id: 1,
            title: `python3 -m pip install -f https://release.oneflow.info oneflow==0.4.0+cu102`,
            date: `5h ago`,
            commentCount: 5,
            shareCount: 2,
          },
          {
            id: 2,
            title: "So you`ve bought coffee... now what?",
            date: `2h ago`,
            commentCount: 3,
            shareCount: 2,
          },
        ],
      ),
      (
        "CPU",
        [
          {
            id: 1,
            title: `Is tech making coffee better or worse?`,
            date: `Jan 7`,
            commentCount: 29,
            shareCount: 16,
          },
          {
            id: 2,
            title: `The most innovative things happening in coffee`,
            date: `Mar 19`,
            commentCount: 24,
            shareCount: 12,
          },
        ],
      ),
      (
        "CUDA-XLA",
        [
          {
            id: 1,
            title: `Ask Me Anything: 10 answers to your questions about coffee`,
            date: `2d ago`,
            commentCount: 9,
            shareCount: 5,
          },
          {
            id: 2,
            title: "The worst advice we`ve ever heard about coffee",
            date: `4d ago`,
            commentCount: 1,
            shareCount: 2,
          },
        ],
      ),
    ])
  )
  <Hero>
    <div
      className=`rounded-xl overflow-hidden bg-gradient-to-r from-sky-400 to-blue-600 flex flex-col items-center justify-center w-full`>
      <div className="w-full max-w-md px-2 py-16 sm:px-0">
        <Tab.Group>
          <Tab.List className="flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl">
            {({selectedIndex}) =>
              builds
              |> Js.Array.map((category: string) => <Variant.Option name=category />)
              |> React.array}
          </Tab.List>
        </Tab.Group>
        <Tab.Group>
          <Tab.List className="my-1 flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl">
            {({selectedIndex}) =>
              Js.Dict.keys(categories)
              |> Js.Array.map((category: string) => <Variant.Option name=category />)
              |> React.array}
          </Tab.List>
        </Tab.Group>
        <Tab.Group>
          <Tab.List className="flex p-1 space-x-1 bg-blue-900 bg-opacity-20 rounded-xl">
            {({selectedIndex}) =>
              allCudaVersions
              |> Js.Array.map((category: string) => <Variant.Option name=category />)
              |> React.array}
          </Tab.List>
          <Tab.Panels className="mt-2">
            {_ =>
              categories
              |> Js.Dict.values
              |> Js.Array.mapi((posts, idx) =>
                <Tab.Panel
                  key={string_of_int(idx)}
                  className={_ =>
                    Js.Array.joinWith(
                      " ",
                      [
                        `bg-white rounded-xl p-3`,
                        `focus:outline-none focus:ring-2 ring-offset-2 ring-offset-blue-400 ring-white ring-opacity-60`,
                      ],
                    )}>
                  {_ => React.string(posts[0].title)}
                </Tab.Panel>
              )
              |> React.array}
          </Tab.Panels>
        </Tab.Group>
      </div>
    </div>
  </Hero>
}
