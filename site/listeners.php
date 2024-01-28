<?php
ini_set('display_errors', 'On');
error_reporting(E_ALL);

$data = file_get_contents('http://icecast:8000/status-json.xsl');
$json = json_decode($data, true);
$title = $json['icestats']['source']['title'];
$listeners = $json['icestats']['source']['listeners'];
$listener_peak = $json['icestats']['source']['listener_peak'];

echo "<p>Now playing: $title</p>";
echo "<p>Current Listeners: $listeners</p>";
echo "<p>Peak Listeners: $listener_peak</p>";
?>
