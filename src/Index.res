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
  <div className=`flex flex-col items-center justify-center w-full`>
    <div className="w-full max-w-md px-2 py-16 sm:px-0">
      <Tab.Group>
        <Tab.List className="flex p-1 space-x-1 bg-blue-900/20 rounded-xl">
          {({selectedIndex}) =>
            Js.Dict.keys(categories)
            |> Js.Array.map((category: string) =>
              <Tab
                key={category}
                className={({selected}) =>
                  Js.Array.joinWith(
                    " ",
                    [
                      `w-full py-2.5 text-sm leading-5 font-medium text-blue-700 rounded-lg`,
                      `focus:outline-none focus:ring-2 ring-offset-2 ring-offset-blue-400 ring-white ring-opacity-60`,
                      selected
                        ? `bg-white shadow`
                        : `text-blue-100 hover:bg-white/[0.12] hover:text-white`,
                    ],
                  )}>
                {({selected}) => React.string(category)}
              </Tab>
            )
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
}
