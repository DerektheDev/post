$(function(){
  $('.preview.btn').click(function(e){
    var cid = $(this).attr('cid');
    $.get( "/campaigns/"+cid+"/preview")
    .done(function( data ) {
      alert( "Data Loaded: " + data );
    });
  })
})