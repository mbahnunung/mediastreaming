<?php

if ($_ENV['ICECAST_ADMIN_PASSWORD'] != $_GET['auth']) {
   echo("Not admin!");
   exit;
}

?>
<html>
  <head>
    <style>
      html { background: #505; color: white; }
    </style>
    <meta http-equiv="refresh" content="10; URL=<?php print($_SERVER['PHP_SELF'].'?auth='.$_GET['auth'].'&action=REFRESH'); ?>" />
  </head>
  <body>
    <form method="GET">
      <input type="hidden" name="auth" value="<?php echo $_GET['auth'] ?>" />
      <input type="submit" name="action" value="NEXT" />
      <input type="submit" name="action" value="INFO" />
      <input type="submit" name="action" value="REFRESH" />
    </form>
    <?php
       include('functions.php');
       if ($_REQUEST['action']) {
         echo '<pre>';
         switch ($_REQUEST['action']) {
           case 'NEXT':
             echo telnet_send("rpr(dot)main.skip");
           break;
           case 'INFO':
             cool_print(get_infos(), 'debug');
           break;
           case 'DIRE':
             echo "TODO";
           break;
           case 'REQUEST':
             echo "TODO";
           break;
           case 'REFRESH':
           break;
           default:
             print_r($_REQUEST);
             print_r($_ENV);
           break;
         }
         echo '</pre>';
       }
       ?>
    <table border="1">
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
