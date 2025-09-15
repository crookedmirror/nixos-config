# Real which
function rich() {
  realpath $(which -- "$@")
}
