import os
import subprocess
import shutil
import json
import platform

GODOT_BINARIES_FOLDER = "D:/PROJETS/INFO/GODOT/bin"
LAST_RESULTS_FILE = "results/last_results.json"

# Higher value increases precision of micro benchmarks but makes them slower to complete
ITERATIONS = 1000000

# Set this to true so all tests will complete very fast.
# This makes results irrelevant, but it allows to test if they all run correctly at all.
FASTRUN = False

# Set this to true to have tests print more stuff.
# This is nice to see more details about running tests (but results are saved anyways)
VERBOSE = True

# Set this to true to run micro benchmarks
RUN_MICRO_BENCHMARKS = True

# Set this to true to run scale benchmarks
RUN_SCALE_BENCHMARKS = True

# Set this to the name of a scale benchmark to run only that one
SINGLE_SCALE_BENCHMARK = ""#"sprite_spam"

# Info about all Godot executables by version
VERSIONS = [
    { "v": [1, 1, 0], "x": "Godot_v1.1_stable_win64" },

    { "v": [2, 0, 0], "x": "godot_2_0_0" },
    { "v": [2, 0, 2], "x": "godot_2_0_2" },
    { "v": [2, 0, 3], "x": "godot_2_0_3" },
    { "v": [2, 0, 4], "x": "Godot_v2.0.4_stable_win64" },
    { "v": [2, 0, 4, 1], "x": "Godot_v2.0.4.1_stable_win64" },

    { "v": [2, 1, 0], "x": "Godot_v2.1_beta_20160712_win64" },
    { "v": [2, 1, 0], "x": "Godot_v2.1_rc1_win64" },
    { "v": [2, 1, 0], "x": "Godot_v2.1_rc2_win64" },
    { "v": [2, 1, 0], "x": "Godot_v2.1-stable_win64" },
    { "v": [2, 1, 1], "x": "Godot_v2.1.1-stable_win64" },
    { "v": [2, 1, 2], "x": "Godot_v2.1.2-stable_win64" },
    { "v": [2, 1, 3], "x": "Godot_v2.1.3-stable_win64" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-beta_20170625_win64" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-beta_20170731_win64" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-stable_win64" },
    { "v": [2, 1, 5], "x": "Godot_v2.1.5-beta1_win64" },
    { "v": [2, 1, 5], "x": "Godot_v2.1.5-rc1_win64" },
    { "v": [2, 1, 5], "x": "Godot_v2.1.5-rc2_win64" },
    { "v": [2, 1, 5], "x": "Godot_v2.1.5-stable_win64" },

    { "v": [3, 0, 0], "x": "Godot_v3.0-alpha1_win64" },
    { "v": [3, 0, 0], "x": "Godot_v3.0-alpha2_win64" },
    { "v": [3, 0, 0], "x": "Godot_v3.0-beta1_win64" },
    { "v": [3, 0, 0], "x": "Godot_v3.0-beta2_win64" },
    { "v": [3, 0, 0], "x": "Godot_v3.0-rc1_win64" },
    { "v": [3, 0, 0], "x": "Godot_v3.0-rc2_win64" },
    { "v": [3, 0, 0], "x": "Godot_v3.0-rc3_win64" },
    { "v": [3, 0, 0], "x": "Godot_v3.0-stable_win64" },
    { "v": [3, 0, 1], "x": "Godot_v3.0.1-rc1_win64" },
    { "v": [3, 0, 1], "x": "Godot_v3.0.1-stable_win64" },
    { "v": [3, 0, 2], "x": "Godot_v3.0.2-stable_win64" },
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-rc1_win64" },
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-rc3_win64" },
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-stable_win64" },
    { "v": [3, 0, 4], "x": "Godot_v3.0.4-stable_win64" },
    { "v": [3, 0, 5], "x": "Godot_v3.0.5-stable_win64" },
    { "v": [3, 0, 6], "x": "Godot_v3.0.6-stable_win64" },

    { "v": [3, 1, 0], "x": "Godot_v3.1-alpha1_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-alpha2_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-alpha3_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-alpha4_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-alpha5_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-beta1_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-beta2_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-beta3_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-beta4_win64" },
    { "v": [3, 1, 0], "x": "Godot_v3.1-beta5_win64" },
]


def main():
    print("Hello!")
    if not check_paths():
        return

    min_version = [1, 1]
    max_version = [3, 1]

    min_version = pad_version(min_version)
    max_version = pad_version(max_version)

    versions = list(filter(lambda v: is_version_in_range(v["v"], min_version, max_version), VERSIONS))
    #versions = [{ "v": [3, 1, 0], "x": "Godot_v3.1-beta5_win64" }]

    for info in versions:
        print("=======================================================================")

        if RUN_MICRO_BENCHMARKS:
            print("Running micro benchmarks for ", info["x"], "...")
            run_micro_benchmarks(info["v"], info["x"])

        if RUN_SCALE_BENCHMARKS:
            print("Running scale benchmarks for ", info["x"], "...")
            run_scale_benchmarks(info["v"], info["x"])

        write_extra_data(info["x"])

    print("Done")


def check_paths():
    ok = True
    for version_info in VERSIONS:
        path = get_runnable_path(version_info["x"])
        if not os.path.isfile(path):
            print("ERROR: path", path, "doesn't exist")
            ok = False
    return ok


def flatten_version(v):
    f = 0
    p = 1
    for i in range(2, -1, -1):
        f += p * v[i]
        p *= 100
    return f


def is_version_in_range(v, min_version, max_version):
    fmin = flatten_version(min_version)
    fmax = flatten_version(max_version)
    f = flatten_version(v)
    #print("testing ", v, ", as ", f)
    return f >= fmin and f <= fmax


def pad_version(v):
    while len(v) < 3:
        v.append(0)
    return v


def get_runnable_path(godot_exe_name):
    return os.path.join(GODOT_BINARIES_FOLDER, godot_exe_name) + "." + get_runnable_extension()


def get_runnable_extension():
    # TODO Detect platform
    return "exe"


def get_project_dir_name(godot_version):
    
    d = "project" + str(godot_version[0])

    if godot_version[0] >= 3 and godot_version[1] > 0:
        # Versions after 3 became forward-compatible only,
        # so I can't keep the same project for a minor versions anymore
        d += str(godot_version[1])

    return d


def merge_json_data(src_data, dst_json_path):
    dst_data = {}
    if os.path.isfile(dst_json_path):
        with open(dst_json_path) as f:
            dst_data = json.load(f)

    for k in src_data:
        dst_data[k] = src_data[k]

    with open(dst_json_path, 'w') as f:
        json.dump(dst_data, f)


def run_micro_benchmarks(version, godot_exe_name):
    godot_exe_fullpath = get_runnable_path(godot_exe_name)
    results_path = LAST_RESULTS_FILE

    if os.path.isfile(results_path):
        os.remove(results_path)

    args = [godot_exe_fullpath, "--iterations=" + str(ITERATIONS)]
    if not VERBOSE or FASTRUN:
        args.append("--noprint")
    if FASTRUN:
        args.append("--fastrun")

    os.chdir(get_project_dir_name(version))
    subprocess.run(args)
    os.chdir("..")

    print("")
    if not os.path.isfile(results_path):
        print("Something went wrong with the results.")
    else:
        with open(results_path) as f:
            data = json.load(f)
        merge_json_data({"micro_benchmarks": data["test_results"]}, "results/" + godot_exe_name + ".json")
        #shutil.copyfile(LAST_RESULTS_FILE, "results/" + godot_exe_name + ".json")
        # TODO Remove last results file! That should be a rename


def run_scale_benchmarks(version, godot_exe_name):
    godot_exe_fullpath = get_runnable_path(godot_exe_name)

    os.chdir(get_project_dir_name(version))

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

    results_data = {}

    for benchmark_dir in benchmark_dirs:
        results_path = os.path.join("scale_benchmarks", benchmark_dir, "results.json")

        if os.path.isfile(results_path):
            os.remove(results_path)

        scene_name = benchmark_dir + ".tscn"
        args = [godot_exe_fullpath, os.path.join("scale_benchmarks", benchmark_dir, scene_name)]

        if not VERBOSE or FASTRUN:
            args.append("--noprint")
        if FASTRUN:
            args.append("--fastrun")

        subprocess.run(args)

        print("")
        if not os.path.isfile(results_path):
            print("Something went wrong with the results.")
        else:
            with open(results_path) as f:
                data = json.load(f)
            results_data[benchmark_dir] = data

    os.chdir("..")

    merge_json_data({"scale_benchmarks": results_data}, "results/" + godot_exe_name + ".json")


def write_extra_data(godot_exe_name):
    extra_data = {}

    godot_exe_fullpath = get_runnable_path(godot_exe_name)
    xs = os.stat(godot_exe_fullpath)
    extra_data["editor_executable_size"] = xs.st_size

    extra_data["editor_executable_name"] = godot_exe_name
    extra_data["cpu_name"] = platform.processor()

    dst_path = "results/" + godot_exe_name + ".json"
    merge_json_data(extra_data, dst_path)


main()
