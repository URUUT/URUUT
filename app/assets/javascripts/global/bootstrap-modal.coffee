# =========================================================
# * bootstrap-modal.js v2.1.1
# * http://twitter.github.com/bootstrap/javascript.html#modals
# * =========================================================
# * Copyright 2012 Twitter, Inc.
# *
# * Licensed under the Apache License, Version 2.0 (the "License");
# * you may not use this file except in compliance with the License.
# * You may obtain a copy of the License at
# *
# * http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# * ========================================================= 
not ($) ->
  "use strict" # jshint ;_;
  
  # MODAL CLASS DEFINITION
  #  * ====================== 
  Modal = (element, options) ->
    @options = options
    @$element = $(element).delegate("[data-dismiss=\"modal\"]", "click.dismiss.modal", $.proxy(@hide, this))
    @options.remote and @$element.find(".modal-body").load(@options.remote)

  Modal:: =
    constructor: Modal
    toggle: ->
      this[(if not @isShown then "show" else "hide")]()

    show: ->
      that = this
      e = $.Event("show")
      @$element.trigger e
      return $("body").addClass("modal-open")  if @isShown or e.isDefaultPrevented()
      @isShown = true
      @escape()
      @backdrop ->
        transition = $.support.transition and that.$element.hasClass("fade")
        that.$element.appendTo document.body  unless that.$element.parent().length #don't move modals dom position
        that.$element.show()
        that.$element[0].offsetWidth  if transition # force reflow
        that.$element.addClass("in").attr("aria-hidden", false).focus()
        that.enforceFocus()
        (if transition then that.$element.one($.support.transition.end, ->
          that.$element.trigger "shown"
        ) else that.$element.trigger("shown"))


    hide: (e) ->
      e and e.preventDefault()
      that = this
      e = $.Event("hide")
      @$element.trigger e
      return @isShown = false  if not @isShown or e.isDefaultPrevented()
      $("body").removeClass "modal-open"
      @escape()
      $(document).off "focusin.modal"
      @$element.removeClass("in").attr "aria-hidden", true
      (if $.support.transition and @$element.hasClass("fade") then @hideWithTransition() else @hideModal())

    enforceFocus: ->
      that = this
      $(document).on "focusin.modal", (e) ->
        that.$element.focus()  if that.$element[0] isnt e.target and not that.$element.has(e.target).length


    escape: ->
      that = this
      if @isShown and @options.keyboard
        @$element.on "keyup.dismiss.modal", (e) ->
          e.which is 27 and that.hide()

      else @$element.off "keyup.dismiss.modal"  unless @isShown

    hideWithTransition: ->
      that = this
      timeout = setTimeout(->
        that.$element.off $.support.transition.end
        that.hideModal()
      , 500)
      @$element.one $.support.transition.end, ->
        clearTimeout timeout
        that.hideModal()


    hideModal: (that) ->
      @$element.hide().trigger "hidden"
      @backdrop()

    removeBackdrop: ->
      @$backdrop.remove()
      @$backdrop = null

    backdrop: (callback) ->
      that = this
      animate = (if @$element.hasClass("fade") then "fade" else "")
      if @isShown and @options.backdrop
        doAnimate = $.support.transition and animate
        @$backdrop = $("<div class=\"modal-backdrop " + animate + "\" />").appendTo(document.body)
        @$backdrop.click $.proxy(@hide, this)  unless @options.backdrop is "static"
        @$backdrop[0].offsetWidth  if doAnimate # force reflow
        @$backdrop.addClass "in"
        (if doAnimate then @$backdrop.one($.support.transition.end, callback) else callback())
      else if not @isShown and @$backdrop
        @$backdrop.removeClass "in"
        (if $.support.transition and @$element.hasClass("fade") then @$backdrop.one($.support.transition.end, $.proxy(@removeBackdrop, this)) else @removeBackdrop())
      else callback()  if callback

  
  # MODAL PLUGIN DEFINITION
  #  * ======================= 
  $.fn.modal = (option) ->
    @each ->
      $this = $(this)
      data = $this.data("modal")
      options = $.extend({}, $.fn.modal.defaults, $this.data(), typeof option is "object" and option)
      $this.data "modal", (data = new Modal(this, options))  unless data
      if typeof option is "string"
        data[option]()
      else data.show()  if options.show


  $.fn.modal.defaults =
    backdrop: true
    keyboard: true
    show: true

  $.fn.modal.Constructor = Modal
  
  # MODAL DATA-API
  #  * ============== 
  $ ->
    $("body").on "click.modal.data-api", "[data-toggle=\"modal\"]", (e) ->
      $this = $(this)
      href = $this.attr("href")
      $target = $($this.attr("data-target") or (href and href.replace(/.*(?=#[^\s]+$)/, ""))) #strip for ie7
      option = (if $target.data("modal") then "toggle" else $.extend(
        remote: not /#/.test(href) and href
      , $target.data(), $this.data()))
      e.preventDefault()
      $target.modal(option).one "hide", ->
        $this.focus()



(window.jQuery)