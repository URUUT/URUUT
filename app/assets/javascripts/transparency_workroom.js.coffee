deleteImages = ->
  $(".image-delete-button").click ->
    confirmation = confirm("Are you sure you want to delete?")
    if confirmation is true
      $(this).parent().remove()
      $.ajax url: $(this).attr("data-href")

$(".new-document-button").click ->
  projectId = $(this).attr("project_id")
  filepicker.pick
    openTo: "COMPUTER"
    extensions: [".doc", ".pdf", ".ppt", ".txt", ".xls", ".docx"]
    services: ["COMPUTER", "BOX", "DROPBOX", "EVERNOTE", "FTP", "GOOGLE_DRIVE", "SKYDRIVE"]
  , ((e) ->
    fileUrl = e.url
    fileName = e.filename
    $.ajax
      url: "/project_admin/documents.js"
      type: "POST"
      data:
        url: fileUrl
        filename: fileName
        project_id: projectId

      success: (data) ->
        deleteImages()

  ), (e) ->
    console.log JSON.stringify(e)

$(".upload-photo-button").click ->
  projectId = $(this).attr("project_id")
  filepicker.pick
    openTo: "COMPUTER"
    mimetypes: "image/*"
    services: ["BOX", "COMPUTER", "FACEBOOK", "DROPBOX", "INSTAGRAM", "FLICKR", "PICASA"]
  , ((e) ->
    fileUrl = e.url
    $.ajax
      url: "/galleries/save_photo_tw_room.js"
      type: "POST"
      data:
        file_url: fileUrl
        mimetype: "image"
        project_id: projectId

  ), (e) ->
    console.log JSON.stringify(e)


$(".upload-video-button").on "click", ->
  $("#save-video").modal "show"


deleteImages()