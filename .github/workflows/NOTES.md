# QUBOInstancesData.jl ${TAG} Release Notes

## `Artifact.toml`

```toml
[collections]
git-tree-sha1 = "${GIT_TREE_SHA1}"
lazy          = true

    [[collections.download]]
    url    = "https://github.com/pedromxavier/QUBOInstanceData/releases/download/${TAG}/collections.tar.gz"
    sha256 = "${SHA_256}"
```