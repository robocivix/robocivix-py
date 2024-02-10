version_file = "VERSION"

with open(version_file, "rt") as f:
    v = f.read().strip()
    i = v.rindex(".") + 1
    rev = int(v[i:])
    rev += 1
    VERSION = v[:i] + str(rev)
    print("Bumping version to", VERSION)

with open(version_file, "wt") as f:
    f.write(VERSION)
