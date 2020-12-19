import subprocess

from denite.base.source import Base
from denite.kind.base import Base as KindBase
from denite.util import globruntime, Nvim, UserContext, Candidates


class Source(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
        self.vim = vim
        self.name = 'pj'
        self.kind = SourceKind(vim)

    def on_init(self, context: UserContext) -> None:
        context["project_roots"] = ["~/src", "~/personalsrc"]

    def gather_candidates(self, context: UserContext) -> Candidates:
        args = ["pj", ".git"]
        for root in context.get("project_roots", []):
            args.append(root)
        pj_results = subprocess.run(args, capture_output=True, encoding="utf8")
        # TODO: this has a bug where, if the input has an escaped space, it
        # will still split it into two different tokens.
        candidates = []
        for dir in pj_results.stdout.split():
            candidates.append({
                "word": dir,
            })
        return candidates


class SourceKind(KindBase):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)
        self.default_action = "open"
        self.vim = vim

    def action_open(self, context: UserContext):
        target = context["targets"][0]["word"]
        self.vim.command(f":cd {target}")
        self.vim.command(":DeniteProjectDir file/rec")
