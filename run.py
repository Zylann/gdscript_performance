import os
import subprocess
import shutil

GODOT_BINARIES_FOLDER = "D:/PROJETS/INFO/GODOT/bin"
LAST_RESULTS_FILE = "results/last_results.json"

# Higher value increases precision of micro benchmarks but makes them slower to complete
ITERATIONS = 1000000

# Set this to true so all tests will complete very fast.
# This makes results irrelevant, but it allows to test if they all run correctly at all.
FASTRUN = False

# Set this to true to have tests print more stuff (but results are saved anyways)
VERBOSE = False

# Set this to true to run micro benchmarks
RUN_MICRO_BENCHMARKS = True

# Set this to true to run scale benchmarks
RUN_SCALE_BENCHMARKS = False

# Set this to the name of a scale benchmark to run only that one
SINGLE_SCALE_BENCHMARK = ""#"sprite_spam"

# Info about all Godot executables by version
VERSIONS = [
    { "v": [1, 1], "x": "Godot_v1.1_stable_win64" },

    { "v": [2, 0, 0], "x": "godot_2_0_0" },
    { "v": [2, 0, 2], "x": "godot_2_0_2" },
    { "v": [2, 0, 3], "x": "godot_2_0_3" },
    { "v": [2, 0, 4, 1], "x": "Godot_v2.0.4.1_stable_win64" },
    { "v": [2, 0, 4], "x": "Godot_v2.0.4_stable_win64" },

    { "v": [2, 1], "x": "Godot_v2.1_beta_20160712_win64" },
    { "v": [2, 1], "x": "Godot_v2.1_rc1_win64" },
    { "v": [2, 1], "x": "Godot_v2.1_rc2_win64" },
    { "v": [2, 1], "x": "Godot_v2.1-stable_win64" },
    { "v": [2, 1, 1], "x": "Godot_v2.1.1-stable_win64" },
    { "v": [2, 1, 2], "x": "Godot_v2.1.2-stable_win64" },
    { "v": [2, 1, 3], "x": "Godot_v2.1.3-stable_win64" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-beta_20170625_win64" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-beta_20170731_win64" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-stable_win64" },

    { "v": [3, 0], "x": "Godot_v3.0-alpha1_win64" },
    { "v": [3, 0], "x": "Godot_v3.0-alpha2_win64" },
    { "v": [3, 0], "x": "Godot_v3.0-beta1_win64" },
    { "v": [3, 0], "x": "Godot_v3.0-beta2_win64" },
    { "v": [3, 0], "x": "Godot_v3.0-rc1_win64" },
    { "v": [3, 0], "x": "Godot_v3.0-rc2_win64" },
    { "v": [3, 0], "x": "Godot_v3.0-rc3_win64" },
    { "v": [3, 0], "x": "Godot_v3.0-stable_win64" },
    { "v": [3, 0, 1], "x": "Godot_v3.0.1-rc1_win64"},
    { "v": [3, 0, 1], "x": "Godot_v3.0.1-stable_win64"},
    { "v": [3, 0, 2], "x": "Godot_v3.0.2-stable_win64"},
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-rc1_win64"},
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-rc3_win64"},
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-stable_win64"},
    { "v": [3, 0, 4], "x": "Godot_v3.0.4-stable_win64"}
]


def main():
    print("Hello!")
    if not check_paths():
        return

    versions = VERSIONS #[{ "v": [3, 0], "x": "Godot_v3.0-stable_win64.exe" }]

    if RUN_MICRO_BENCHMARKS:
        for info in versions:
            print("Running ", info["x"], "...")
            run_micro_benchmarks(info["v"], info["x"])

    if RUN_SCALE_BENCHMARKS:
        for info in versions:
            print("Running ", info["x"], "...")
            run_scale_benchmarks(info["v"], info["x"])

    print("Done")


def check_paths():
    ok = True
    for version_info in VERSIONS:
        path = get_runnable_path(version_info["x"])
        if not os.path.isfile(path):
            print("ERROR: path", path, "doesn't exist")
            ok = False
    return ok


def get_runnable_path(godot_exe_name):
    return os.path.join(GODOT_BINARIES_FOLDER, godot_exe_name) + "." + get_runnable_extension()


def get_runnable_extension():
    # TODO Detect platform
    return "exe"


def run_micro_benchmarks(version, godot_exe_name):
    godot_exe_fullpath = get_runnable_path(godot_exe_name)

    if os.path.isfile(LAST_RESULTS_FILE):
        os.remove(LAST_RESULTS_FILE)

    args = [godot_exe_fullpath, "--iterations=" + str(ITERATIONS)]
    if not VERBOSE:
        args.append("--noprint")
    if FASTRUN:
        args.append("--fastrun")

    os.chdir("project" + str(version[0]))
    subprocess.run(args)
    os.chdir("..")

    print("")
    if not os.path.isfile(LAST_RESULTS_FILE):
        print("Something went wrong with the results.")
    else:
        godot_name = os.path.splitext(godot_exe_name)[0]
        shutil.copyfile(LAST_RESULTS_FILE, "results/" + godot_name + ".json")
        # TODO Remove last results file! That should be a rename


def run_scale_benchmarks(version, godot_exe_name):
    godot_exe_fullpath = get_runnable_path(godot_exe_name)

    os.chdir("project" + str(version[0]))

    if not os.path.isdir("scale_benchmarks"):
        print("No scale benchmarks for that version of Godot")
        os.chdir("..")
        return

    benchmark_dirs = filter(lambda x: os.path.isdir(os.path.join("scale_benchmarks", x)), os.listdir("scale_benchmarks"))

    if SINGLE_SCALE_BENCHMARK != "":
        for d in benchmark_dirs:
            if d == SINGLE_SCALE_BENCHMARK:
                benchmark_dirs = [d]
                break

    for benchmark_dir in benchmark_dirs:
        results_path = os.path.join("scale_benchmarks", benchmark_dir, "results.json")

        if os.path.isfile(results_path):
            os.remove(results_path)

        args = [godot_exe_fullpath, os.path.join("scale_benchmarks", benchmark_dir, "main.tscn")]

        if FASTRUN:
            args.append("--fastrun")

        subprocess.run(args)

        print("")
        if not os.path.isfile(results_path):
            print("Something went wrong with the results.")

    os.chdir("..")


main()
