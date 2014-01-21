var img;

$(function () {
  // file upload drag and drop
  $('#dropzone').bind({
    mouseenter: function (event){
      // $(this).data('hover',1);
    },
    mouseleave: function (event){
      // $(this).data('hover',0);
      $(this).removeClass('alert-success', 250);
    },
    dragenter: function (event){
      $(this).addClass('alert-success', 250);
    },
    dragleave: function (event){
      $(this).removeClass('alert-success', 250);
    },
    drop: function (event){
      $(this).removeClass('alert-success', 250);

      var formData = new FormData();
      var file = event.originalEvent.dataTransfer.files[0];
      // var uuid = Math.floor(Math.random() * 10000000000);

      formData.append('upload', file);
      // formData.append('uploadSize', file.size);
      // formData.append('X-Progress-ID', uuid);


      $('#progress-target').show();

      // get progress
      // setInterval( function(){
      //   $.get('/progress', {
      //     'X-Progress-ID': uuid
      //   })
      //   .done(function(data) {
      //     var upload = $.parseJSON(data);
      //     console.log(upload);
      //   }).fail(function() {
      //     console.log("oops...");
      //   })
      // }, 250);


      // post data
      $.ajax({
        type: 'POST',
        url: "/resources?X-Progress-ID="+uuid,
        processData: false,
        contentType: false,
        data: formData,
        xhrFields: {
          // add listener to XMLHTTPRequest object directly for progress (jquery doesn't have this yet)
          onprogress: function (progress) {
            // calculate upload progress
            var percentage = Math.floor((progress.total / progress.totalSize) * 100);
            // log upload progress to console
            console.log('progress', percentage);
            if (percentage === 100) {
              console.log('DONE!');
            } else {
              console.log('Not done yet.')
            }
          }
        }
      })

    }
  });

  // Prevent DnD to any other part of the window
  // from taking any action
  $(document).bind('drop dragover', function(event) {
    event.preventDefault();
  })



  // image resource preview
  $('#image-resources li').popover({
    trigger: 'hover',
    placement: 'right',
    content: function(){
      img = "<img src='";
      img += $(this).find('a').attr('data-thumb');
      img += "' />";
      return img;
    },
    callback: function(e){
      $('.popover .popover-content').html(img);
    }
  })

  // load selected resource in view
  $('.resources input[type=radio]').click(function(){
    $(this).closest('form').submit();
  })

});
