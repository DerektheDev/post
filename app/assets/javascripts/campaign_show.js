function fillProgressBar(progressBar, percentage, speed, message, classes){
  $(progressBar).html(message);
  $(progressBar).attr('class', 'progress-bar '+ classes);
  progressBar.animate({
    width: percentage+"%"
  }, speed);
}

var img;

$(function () {

  var progressTarget = $('#progress-target')
  var progressBar = $('#progress-target').find('.progress-bar');


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

      formData.append('upload', file);

      fillProgressBar(progressBar, 0, 0, '');
      progressTarget.fadeIn('fast');

      // post data
      $.ajax({
        type: 'POST',
        url: '/resources',
        processData: false,
        contentType: false,
        data: formData,
        xhr: function(){
          // get the native XmlHttpRequest object
          var xhr = $.ajaxSettings.xhr();
          // set the onprogress event handler
          xhr.upload.onprogress = function(evt){
            percentage = ((evt.loaded/evt.total)*100);
            message = "Uploading...";
            fillProgressBar(progressBar, percentage, 'fast', message);
          }
          // set the onload event handler
          xhr.upload.onload = function(){
            message = "Processing upload...";
            fillProgressBar(progressBar, percentage, 'fast', 'Processing upload...');
          }
          // return the customized object
          return xhr;
        }
      }).done(function(data){
        // uploading and processing are done
        fillProgressBar(progressBar, 100, 'fast', 'Success!', 'progress-bar-success');
      }).fail(function(data){
        fillProgressBar(progressBar, 100, 'fast', 'Something went wrong...', 'progress-bar-danger');
      }).always(function(data){
        setTimeout(function(){
          progressTarget.fadeOut('slow');
        }, 1500);
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
    // progressBar.html('Compiling markup. Please wait...');
    // progressBar.css('width', '100%');
    // progressTarget.fadeIn('fast');

    $(this).closest('form').submit();
    
    // form = $(this).closest('form');
    // action = form.attr('action');
    // $.post(action, {
    //   data: $(form).serialize()
    // }).done(function(data){
    //   fillProgressBar(progressBar, 100, 'fast', 'Compilation successful!', 'progress-bar-success');
    // }).fail(function(data){
    //   fillProgressBar(progressBar, 100, 'fast', 'Compilation failed...', 'progress-bar-danger');
    // }).always(function(data){
    //   setTimeout(function(){
    //     progressTarget.fadeOut('slow');
    //   }, 1500);
    // })
  })

});
