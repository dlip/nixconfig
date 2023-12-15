def greet [name = "nushell"] {
  $"hello ($name)"
}

def ngl [] {git log | jc --git-log | from json}
def ndps [] {docker ps --format="{{ json .}}" | lines | each { from json }}
