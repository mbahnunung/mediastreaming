#!/usr/bin/env liquidsoap

%include "utils.liq"

# CONFIGS
set("log.file", true)
set("log.stdout", true)
set("log.level", 2)
set("log.file.path", "/logs/main.log")
set("server.telnet", true)
set("server.telnet.port", 5000)
set("server.telnet.bind_addr", "0.0.0.0")

# INPUTS
archives = mksafe(
    audio_to_stereo(
        playlist.safe(
            reload=60,
            "/playlists/shows",
            mode="random"
            )
        )
    )

live_rpr = audio_to_stereo(
    rewrite_metadata(
        [
            ("artist", "$(title)"),
            ("title", "L I V E"),
            ("comment", "https://ravepartyradio.org")
            ],
        stretch(
            ratio=interactive.float("test", 1.00000),
            input.harbor(
                "rpr.live",
                id="rpr.live",
                port=5002,
                password=my_getenv("LIVE_PASSWORD"),
                user="source",
                logfile="/logs/live.log"
                )
            )
        )
    )

live_guest = audio_to_stereo(
    rewrite_metadata(
        [
            ("artist", "Please stand by for the next live stream"),
            ("title", "and drink some water!"),
            ("comment", "https://ravepartyradio.org")
            ],
        stretch(
            ratio=interactive.float("test", 1.00000),
            input.harbor(
                "rpr.guest",
                id="rpr.guest",
                port=5001,
                password=my_getenv("GUEST_PASSWORD"),
                user="source",
                logfile="/logs/guest.log"
                )
            )
        )
    )


mix = fallback(track_sensitive=false, [live_rpr, live_guest, archives])
mix = store_metadata(size=50,id="history",mix)
def feedback(metadata)
   system("echo "^ quote(metadata["artist"] ^" - "^ metadata["title"]) ^" > /data/latest.txt")
   system("echo "^ quote(metadata["artist"] ^" - "^ metadata["title"]) ^" >> /data/history.txt")
end
mix = on_metadata(feedback, mix)


# OUTPUTS
output.icecast(
    password=my_getenv("HARBOR_PASSWORD"),
    host=my_getenv("BROADCAST_PORT_5001_TCP_ADDR"),
    port=int_of_string(my_getenv("BROADCAST_PORT_5001_TCP_PORT")),
    %wav,
    mount="rpr.main",
    mix
    )

file = '%Y-%m-%d %H%M%S - $(if $(title),"$(title)", "Unknown")'
output.file(
    %mp3,
     reopen_on_metadata=false,
     fallible=true,
     "/playlists/live/rpr/" ^ file ^ ".mp3",
     live_rpr
     )
