#!/bin/sh
# beta-follow.sh <tag>: after a release, move that line's beta branch up to it, so the Beta update channel never
# offers an older build than the release (a handheld on Beta installs the tip of its beta branch, not a release).
#   v*-plus tags -> plus-beta (the RG DS Plus line); other v* tags -> beta (the RG DS line).
# It never force-pushes:
#   - beta behind the release (an ancestor of the tag): fast-forward it to the tag;
#   - beta already holds the release (a newer beta in testing): leave it;
#   - the two have split: fail, and say so. A person decides what the beta branch should hold.
# Run from a clone with the tag and the beta branch fetched (release.yml fetches all history).
# DRY_RUN=1: print what it would do, push nothing. REMOTE: the remote to read and push (default origin).
set -eu
TAG=${1:?usage: beta-follow.sh <tag>}
REMOTE=${REMOTE:-origin}
case "$TAG" in
    v*-plus) BR=plus-beta ;;
    v*) BR=beta ;;
    *) echo "beta-follow: $TAG is not a release tag; nothing to do"; exit 0 ;;
esac
T=$(git rev-parse "$TAG^{commit}")
if ! B=$(git rev-parse -q --verify "refs/remotes/$REMOTE/$BR^{commit}"); then
    echo "beta-follow: no $REMOTE/$BR branch; nothing to move"
    exit 0
fi
if [ "$B" = "$T" ]; then
    echo "beta-follow: $BR is already at $TAG"
elif git merge-base --is-ancestor "$T" "$B"; then
    echo "beta-follow: $BR ($(git rev-parse --short "$B")) already holds $TAG; left as it is"
elif git merge-base --is-ancestor "$B" "$T"; then
    echo "beta-follow: moving $BR from $(git rev-parse --short "$B") to $TAG ($(git rev-parse --short "$T"))"
    [ "${DRY_RUN:-0}" = 1 ] || git push "$REMOTE" "$T:refs/heads/$BR"
else
    echo "::error::beta-follow: $BR ($(git rev-parse --short "$B")) and $TAG have split. Beta users would be offered" \
         "$BR, not $TAG. Decide by hand, for example: archive $BR's tip with a tag, then point $BR at $TAG."
    exit 1
fi
