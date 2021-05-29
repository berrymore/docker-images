usage() {
cat << EOF

Usage: build.sh -i [image] -v [version] -t [target]
Build a Docker Image

Parameters:
  -i: image to build. Required.
      Choose one of: $(for i in $(ls -d */); do printf "%s" "${i%%/} "; done)
  -v: version to build. Required.
  -t: target of multi stage building. Default: base

EOF
  exit 0
}

if [ "$#" -eq 0 ]; then usage; fi

# Parameters
IMAGE="undefined"
VERSION="undefined"
TARGET="base"

while getopts "i:v:t:h:" optname; do
  case "$optname" in
    i) IMAGE="$OPTARG";;
    v) VERSION="$OPTARG";;
    t) TARGET="$OPTARG";;
    h) usage;;
    *) echo "Unknown error while processing options inside build.sh";;
  esac
done

IMAGE_NAME="berrymore/$IMAGE:$VERSION-$TARGET"

cd "$IMAGE/$VERSION" || exit 1

echo "====================="
echo "Building image '$IMAGE_NAME'"

docker build -t "$IMAGE_NAME" --target=$TARGET -f Dockerfile . || {
  echo "There was an error building the image."
  exit 1
}

echo ""

if [ $? -eq 0 ]; then
cat << EOF
  $IMAGE Docker image for version $VERSION is ready:

    --> $IMAGE_NAME
EOF
else
  echo "$IMAGE Docker Image was NOT successfully created. Check the output and correct any reported problems with the docker build operation."
fi