<?php include('functions.php'); ?>
<html>
  <head>
    <style>
      html { background: #505; color: white; }
    </style>
    <meta http-equiv="refresh" content="10; URL=<?php print($_SERVER['PHP_SELF'].'?auth='.$_GET['auth'].'&action=REFRESH'); ?>" />
  </head>
  <body>
    <table border="0">
      <thead>
        <th>Artist</th>
        <th>Title</th>
      </thead>
      <?php foreach (get_metadata() as $song) { ?>
      <tr>
        <td><?php print($song['artist']);?>&nbsp;</td>
        <td><?php print($song['title']);?>&nbsp;</td>
      </tr>
      <?php } ?>
    </table>
  </body>
</html>
