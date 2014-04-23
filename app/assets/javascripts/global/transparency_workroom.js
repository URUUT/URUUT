var deleteImages = function() {
  $(".image-delete-button").click(function() {
    var confirmation;
    confirmation = confirm("Are you sure you want to delete?");
    if (confirmation === true) {
      $(this).parent().remove();
      $.ajax({
        url: $(this).attr("data-href")
      });
    }
  });
};

$(function() {
  $(".new-document-button").click(function() {
    var projectId;
    projectId = $(this).attr("project_id");
    filepicker.pick({
      openTo: "COMPUTER",
      extensions: [".doc", ".pdf", ".ppt", ".txt", ".xls", ".docx"],
      services: ["COMPUTER", "BOX", "DROPBOX", "EVERNOTE", "FTP", "GOOGLE_DRIVE", "SKYDRIVE"]
    }, (function(e) {
      var fileName, fileUrl;
      fileUrl = e.url;
      fileName = e.filename;
      $.ajax({
        url: "/project_admin/documents.js",
        type: "POST",
        data: {
          url: fileUrl,
          filename: fileName,
          project_id: projectId
        }
      });
    }), function(e) {
      console.log(JSON.stringify(e));
    });
  });
  $(".upload-photo-button").click(function() {
    var projectId;
    projectId = $(this).attr("project_id");
    filepicker.pick({
      openTo: "COMPUTER",
      mimetypes: "image/*",
      services: ["BOX", "COMPUTER", "FACEBOOK", "DROPBOX", "INSTAGRAM", "FLICKR", "PICASA"]
    }, (function(e) {
      var fileUrl;
      fileUrl = e.url;
      $.ajax({
        url: "/galleries/save_photo_tw_room.js",
        type: "POST",
        data: {
          file_url: fileUrl,
          mimetype: "image",
          project_id: projectId
        }
      });
    }), function(e) {
      console.log(JSON.stringify(e));
    });
  });
  $(".upload-video-button").on("click", function() {
    $("#save-video").modal("show");
  });
  deleteImages();
});