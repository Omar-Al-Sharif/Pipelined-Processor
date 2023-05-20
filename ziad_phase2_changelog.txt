# ChangeLog

Memory-phase2:
### Added
- takes extra parameter (stacken) 
    determines if mem operation involves stack or not
    ex: stacken -> 1 and memWrite -> 1 : push operation
        stacken -> 0 and memWrite -> 1 : store operation

### Changed
- when both memWrite and memRead are 1 then its undefined behavior (make sure controller doesn't send them both for any operation) (assumption thing) 

### Changed
- rewrited code with combinational logic instead of process to avoid output delay when reading from mem.


PC-phase:
### Added
- takes extra parameters branch, branchaddress
    when branch is '1' and clk rising edge (synchronized with clk) the branchaddress is loaded into the current program count and **its not incremented**
    will be incremented from next clk cycle as normal
