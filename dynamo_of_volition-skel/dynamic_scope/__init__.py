from typing import Dict, Any, Iterator, Optional
from collections import abc
from types import FunctionType
import inspect


class DynamicScope(abc.Mapping):
    def __init__(self):
        # Dictionary to store the environment variables
        self.env: Dict[str, Optional[Any]] = {}

    def __getitem__(self, key: str) -> Optional[Any]:
        if key not in self.env.keys():
            # Raise an error if the variable is not defined in the scope
            raise NameError(f"Name '{key}' is not defined.")
        if self.env[key] == '__unbound__':
            # Raise an error if the variable is referenced before assignment
            raise UnboundLocalError(f"Name '{key}' was referenced before assignment.")
        return self.env[key]

    def __setitem__(self, key: str, value: Optional[Any]):
        if key not in self.env.keys():
            # Add a new variable to the scope
            self.env[key] = value

    def __iter__(self) -> Iterator[str]:
        # Provide an iterator over the variable names in the scope
        return self.env.__iter__()

    def __len__(self) -> int:
        # Return the number of variables in the scope
        return len(self.env)


def get_dynamic_re() -> DynamicScope:
    # creating a new instance of dynamic scope
    dyn_scope = DynamicScope()
    # get call stack
    stack = inspect.stack()
    # get code object of the current function
    current_function = inspect.currentframe().f_code

    # iteration over frames in a given call stack
    skip_current = False  # Flag to skip the current function frame
    for frame_info in stack[1:]:
        # gets frame object
        frame = frame_info.frame
        # get code object of current frame
        code = frame.f_code

        if skip_current:
            # Skip the frame if the flag is set
            skip_current = False
            continue

        if code.co_name == current_function.co_name and code.co_filename == current_function.co_filename:
            # Set the flag to skip the current frame and continue to the next one
            skip_current = True
            continue

        # get the free variables
        free_vars = list(code.co_freevars)
        # get local variables that are not free
        local_vars = {key: value for (key, value) in frame.f_locals.items() if key not in free_vars}

        # add local variables to dynamic scope
        for var_name, var_value in local_vars.items():
            dyn_scope[var_name] = var_value

        # Check for if there are no local variables in frame, given there are other variables that exist
        all_vars = code.co_cellvars + code.co_varnames
        if not len(frame.f_locals) and len(all_vars):
            # define as __unbound__ in the dynamic scope
            for var in all_vars:
                dyn_scope[var] = '__unbound__'

    # return the dynamic scope
    return dyn_scope
