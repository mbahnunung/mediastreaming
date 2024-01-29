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
url="https://sv.stri.my.id"

# FUNCTIONS
icecast_out=output.icecast(description=description, genre=genre, url=url)
output_docker_env.icecast = icecast_out(
    host=my_getenv("8360"),
    port=int_of_string(my_getenv("8360")),
    password=my_getenv("bintang95602")
)
def outputs(encoder, rbtfm, input)
    output_docker_env.icecast(encoder, mount=mount, input)
end

input=input.harbor("rpr.main", port=5001, password=my_getenv("HARBOR_PASSWORD"))
input=mksafe(input)

# NORMALIZE
#input=audio_process(input)

# OUTPUTS
outputs(%mp3(bitrate=192), mount="/rbtfm", input)

