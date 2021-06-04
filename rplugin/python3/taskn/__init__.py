"""
Provides integration between taskn (https://github.com/crockeo/taskn)
and taskwiki (https://github.com/tools-life/taskwiki)
by allowing one to open the note associated with a taskwiki entry.
"""

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
        taskn_dir = Path("~/.taskn").expanduser()
        for file in taskn_dir.iterdir():
            if file.name.startswith(sha):
                return file
        return None
