"""
Provides integration between taskn (https://github.com/crockeo/taskn)
and taskwiki (https://github.com/tools-life/taskwiki)
by allowing one to open the note associated with a taskwiki entry.
"""

import json
import subprocess
from pathlib import Path
from typing import cast
from typing import List
from typing import Optional

import pynvim


@pynvim.plugin
class Taskn:
    def __init__(self, nvim: pynvim.Nvim):
        self.nvim = nvim
        pass

    @pynvim.command("OpenTaskNote")
    def open_task_note(self) -> None:
        # TODO: modify this so that it makes more sense
        # in literally any set up other than my own
        file_path = Path(cast(str, self.nvim.call("expand", "%@")))
        if file_path.name == "home.md":
            current_line = self._get_current_line()
            sha_part = self._get_sha_part(current_line)
            if sha_part is None:
                self.nvim.out_write("could not find sha in current line\n")
                return

            taskn_file = self._find_taskn_file(sha_part)
            if taskn_file is None:
                self.nvim.out_write(f"could not find file for sha {sha_part}\n")
                return

            self.nvim.command(f"edit {str(taskn_file)}\n")
        elif file_path.parent.name == ".taskn":
            self.nvim.command(f"edit ~/home.md\n")
        else:
            self.nvim.command(":call vimwiki#base#follow_link('nosplit', 0, 1)\n")

    @pynvim.function("TasknShaPart", sync=True)
    def taskn_entry(self, _: List[str]) -> Optional[str]:
        current_line = self._get_current_line()
        sha_part = self._get_sha_part(current_line)
        return sha_part

    def _get_sha_part(self, line: str) -> Optional[str]:
        _, _, sha_part = line.rpartition("  ")
        if not sha_part.startswith("#"):
            return None

        sha_part = sha_part[1:]
        try:
            int(sha_part, 16)
        except ValueError:
            return None

        return sha_part.strip()

    def _get_current_line(self) -> str:
        # TODO: make this better later if it gets slow
        file_path = cast(str, self.nvim.call("expand", "%@"))
        row = cast(int, self.nvim.call("line", ".")) - 1
        with open(file_path, "r") as fp:
            return fp.readlines()[row]

    def _find_taskn_file(self, sha: str) -> Optional[Path]:
        proc = subprocess.run(["task", "export", sha], stdout=subprocess.PIPE)
        tasks = json.loads(proc.stdout)
        if len(tasks) != 1:
            return None
        return (Path("~/.taskn").expanduser() / tasks[0]["uuid"]).with_suffix(".md")
