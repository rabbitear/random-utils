#!/bin/bash
# Adds GPL3 banner to top of any file.

OUTFILE="${1}"

if [ -e ${OUTFILE}.tmp ]
then
	echo "${OUTFILE}.tmp already exists, stopping."
	exit
fi

cp ${OUTFILE} ${OUTFILE}.tmp

# ------------------------------------------------------------------------ 
# here doc of the gpl banner, take note of the copyright name and date.
(
cat <<EndOfFile
/***********
***********
**
**  Copyright (c) 1999 by Jon Bradley
**  Homebrew is distributed under the terms of the GNU General Public License.
**
**    This file is part of Homebrew-bbs.
**
**    Homebrew-bbs is free software: you can redistribute it and/or modify
**    it under the terms of the GNU General Public License as published by
**    the Free Software Foundation, either version 3 of the License, or
**    (at your option) any later version.
**
**    Homebrew is distributed in the hope that it will be useful,
**    but WITHOUT ANY WARRANTY; without even the implied warranty of
**    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**    GNU General Public License for more details.
**
**    You should have received a copy of the GNU General Public License
**    along with Homebrew.  If not, see <http://www.gnu.org/licenses/>.
**
***********
************/

EndOfFile
) > "${OUTFILE}"
# ------------------------------------------------------------------------ 

cat ${OUTFILE}.tmp >> ${OUTFILE}
rm ${OUTFILE}.tmp

