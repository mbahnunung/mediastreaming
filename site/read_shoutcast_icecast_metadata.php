<?php
function getStreamMetadata($streamUrl) {
	$needle = 'StreamTitle=';
	$ua = 'Dailymate Radio/1.0';

	$opts = ['http' => ['method' => 'GET',
			 			'header' => 'Icy-MetaData: 1',
			 			'user_agent' => $ua]
			];

	$context = stream_context_create($opts);

	$icyMetaIntFound = false;
	$icyInterval = -1;
	$offset = 0;

	if(($headers = get_headers($streamUrl, 0, $context))) {
		foreach($headers as $h) {
			if(!(strpos(strtolower($h), 'icy-metaint:') === false)) {
				$icyMetaIntFound = true;

				$icyInterval = explode(':', $h)[1];

				break;
			}			
		}
	}

	if(!$icyMetaIntFound) {
		echo "icy-metaint header not exists!";

		return;
	}

	if($stream = fopen($streamUrl, 'r', false, $context)) {
		while($buffer = stream_get_contents($stream, $icyInterval, $offset)) {
			if(strpos($buffer, $needle) !== false) {
				fclose($stream);
				
				$title = explode($needle, $buffer)[1];
				return substr($title, 1, strpos($title, ';') - 2);
			}
			
			$offset += $icyInterval;
		}
	}
}

echo getStreamMetadata('http://sukmben.radiogentara.com:8080/gentarahd');
// var_dump(getStreamMetadata('https://freeuk16.listen2myradio.com/live.mp3?typeportmount=s1_23369_stream_600894294'));
// var_dump(getStreamMetadata('http://pu.klikhost.com:7720/;'));