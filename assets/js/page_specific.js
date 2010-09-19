(
  function tubeLineColourExtractor() {
    var table = document.getElementById('tube-line-col');
    
    if ( !table ) { return; }
    
    var rows = table.rows;
    
    rows[0].cells[0].style.paddingLeft = "10px";
    
    for ( var i = 1, len = rows.length; i < len; i++ ) {
      var nameCell = rows[i].cells[0];
      var rgbCell = rows[i].cells[2];
      var rgb = rgbCell.innerText;

      nameCell.style.borderLeft = "10px solid rgba(" + rgb + ",1)";
      nameCell.style.paddingLeft = "5px";
    };
  }
)();