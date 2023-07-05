from typing import Dict, Any, Iterator, Optional
from collections import abc
from types import FunctionType
import inspect

class DynamicScope(abc.Mapping):
    def __init__(self):
        self.env: Dict[str, Optional[Any]] = {}

    def __getitem__(self, key: str):
        if key not in self.env:
            raise NameError(f"Variable '{key}' is not defined in the dynamic scope.")
        elif self.env[key] is "_unbnd_":
            raise UnboundLocalError(f"Variable '{key}' is unbound in the dynamic scope.")
        else:
            return self.env[key]

    def __contains__(self, value: str):
        return self.env.__contains__(value)

    def __len__(self) -> int:
        return len(self.env)

    def __iter__(self):
        return self.env.__iter__()

def get_dynamic_re() -> DynamicScope:
    # Initialize inspect.stack() and create a DynamicScope instance
    stack = inspect.stack()
    dynamic_scope = DynamicScope()

    # Iterate through each frame in the call stack (except the first one)
    for frame_info in stack[1:]:
        frame = frame_info.frame

        # Check if each item in the frame's variables is in the union of co_varnames and co_freevars and not in the locals
        for item in (list(frame.f_code.co_freevars) + list(frame.f_code.co_varnames)):
            if item not in frame.f_locals.keys():
                dynamic_scope.env[item] = "_unbnd_"  # Set the item to "_unbnd_" if it is unbound

        # Add key-value pairs from the frame's local variables to the dynamic environment
        for key, value in frame.f_locals.items():
            if key not in list(frame.f_code.co_freevars) and key not in dynamic_scope.env:
                dynamic_scope.env[key] = value

    return dynamic_scope
