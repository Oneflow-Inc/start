module Link = Next.Link

module Navigation = {
  @react.component
  let make = () =>
    <nav className="p-2 h-12 flex border-b border-gray-200 justify-between items-center text-sm">
      <Link href="/">
        <a className="flex items-center w-1/3">
          <span className="text-xl ml-2 align-middle font-semibold">
            {React.string("OneFlow")}
          </span>
        </a>
      </Link>
      <div className="flex w-2/3 justify-end">
        // <Link href="/"> <a className="px-3"> {React.string("Home")} </a> </Link>
        <a className="px-3 font-bold" target="_blank" href="https://oneflow.org/">
          {React.string("About")}
        </a>
        <a className="px-3 font-bold" target="_blank" href="https://docs.oneflow.org/">
          {React.string("Docs")}
        </a>
        <a className="px-3 font-bold" target="_blank" href="https://github.com/Oneflow-Inc/oneflow">
          {React.string("Github")}
        </a>
      </div>
    </nav>
}

@react.component
let make = (~children) => {
  let minWidth = ReactDOM.Style.make(~minWidth="20rem", ())
  <div style=minWidth className="flex lg:justify-center">
    <div className="max-w-5xl w-full lg:w-3/4 text-gray-900 font-base">
      <Navigation /> <main className="mt-4 mx-4"> children </main>
    </div>
  </div>
}
