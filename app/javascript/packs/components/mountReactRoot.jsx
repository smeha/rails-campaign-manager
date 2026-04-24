import React from "react"
import { createRoot } from "react-dom/client"

const mountedRoots = new Map()

const mountReactRoot = (elementId, Component) => {
  const element = document.getElementById(elementId)
  if (!element) {
    return
  }

  let root = mountedRoots.get(elementId)
  if (!root) {
    root = createRoot(element)
    mountedRoots.set(elementId, root)
  }

  root.render(<Component />)
}

const unmountReactRoots = () => {
  mountedRoots.forEach((root) => root.unmount())
  mountedRoots.clear()
}

document.addEventListener("turbo:before-cache", unmountReactRoots)

export default mountReactRoot
