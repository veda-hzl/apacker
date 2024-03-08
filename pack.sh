#!/bin/bash
. tools/parse_yaml.sh

PACK=tools/makeself.sh

eval $(parse_yaml env.yml)
RUNDIR=$global_rundir
for s in $global_softwares_; do
	software=$(eval echo \$${s}_software)
	ver=$(eval echo \$${s}_version)
	target=$(eval echo \$${s}_target)

	$PACK --notemp --target $target $software $RUNDIR/$software-$ver.run "$software v$ver"  echo "$software has installed."
done

