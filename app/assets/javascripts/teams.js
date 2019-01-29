$(function() {
  $.ajax({
    url: '/tymy',
    dataType: 'json',
    success: function(result) {
      $('#team_name').autocomplete({source: result.teams});
    }
  });
});
