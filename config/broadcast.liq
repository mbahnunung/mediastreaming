#!/usr/bin/env liquidsoap

%include "utils.liq"

# CONFIGS
set("log.file", true)
set("log.stdout", true)
set("log.level", 2)
set("log.file.path", "/logs/broadcast.log")
set("server.telnet", false)

description="Rave Party Radio"
genre="Electronica"
url="https://ravepartyradio.org"

# FUNCTIONS
icecast_out=output.icecast(description=description, genre=genre, url=url)
output_docker_env.icecast = icecast_out(
    host=my_getenv("ICECAST_PORT_8000_TCP_ADDR"),
    port=int_of_string(my_getenv("ICECAST_PORT_8000_TCP_PORT")),
    password=my_getenv("ICECAST_SOURCE_PASSWORD")
)
def outputs(encoder, ~mount, input)
    output_docker_env.icecast(encoder, mount=mount, input)
end

input=input.harbor("rpr.main", port=5001, password=my_getenv("HARBOR_PASSWORD"))
input=mksafe(input)

# NORMALIZE
#input=audio_process(input)

# OUTPUTS
outputs(%mp3(bitrate=192), mount="/ravepartyradio-192.mp3", input)

