# /// script
# dependencies = [
#   "uvtrick",
#   "absl-py",
# ]
# ///
from uvtrick import Env

import json

from absl import app
from absl import flags

FLAGS = flags.FLAGS
flags.DEFINE_string("rootfile", "~/Downloads/zlib9-jagged0.root", "path to root file.")
flags.DEFINE_boolean("gc", True, "turns on pythons GC.")


def loop_iterate(rootfile):
    import uproot
    import resource

    filenames = [{rootfile: "tree"}] * 2
    maxrss = []
    for batch in uproot.iterate(filenames, step_size="500 MB", library="np"):
        maxrss.append(resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)
    return maxrss


def main(argv):
    del argv

    if not FLAGS.gc:
        import gc

        gc.disable()

    # run
    # v5.6.4: latest version at the time of writing
    # v5.4.1: last version with this memory regression (v5.4.2 fixed it)
    for version in ("5.6.4", "5.4.1"):
        if FLAGS.gc:
            import gc

            gc.collect()
        print(
            f"Running '{loop_iterate.__name__}' with uproot=={version} and python 3.12"
        )
        maxrss = Env(f"uproot=={version}", python="3.12").run(
            loop_iterate, rootfile=FLAGS.rootfile
        )

        with open(f"uproot_v{version}__maxrss.json", "w") as f:
            json.dump(maxrss, f, indent=4)


if __name__ == "__main__":
    # uv run uproot_memory_usage.py --nogc
    app.run(main)
