import $ from "jquery"

window.$ = $
window.jQuery = $

console.log("Before Widget import:")
console.log("jQuery:", $.fn.jquery)
console.log("Same instance:", $ === window.jQuery)

import("jquery-ujs").then(() => import("jquery-ui/ui/widget")).then(() => {
  console.log("After Widget import:")
  console.log("Widget:", typeof $.widget)
  console.log("Mouse before import:", typeof $.ui?.mouse)

  return import("jquery-ui/ui/widgets/mouse")
}).then(() => {
  console.log("After Mouse import:")
  console.log("Mouse:", typeof $.ui?.mouse)
  console.log("Mouse prototype:", typeof $.ui?.mouse?.prototype)

  return import("./active_admin/base")
}).catch(error => {
  console.error("ActiveAdmin initialization failed:", error)
})
