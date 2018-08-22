<?php
      $link = mysql_connect('127.0.0.1','root','123456');
      if ($link)
        echo "Success...";
      else
        echo "Failure...";

      mysql_close();
    ?>
