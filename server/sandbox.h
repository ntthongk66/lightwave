/* file: sandbox.c	B. Moody	22 February 2019

Simple sandbox for the LightWAVE server
Copyright (C) 2019 Benjamin Moody

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef LIGHTWAVE_SANDBOX_H
#define LIGHTWAVE_SANDBOX_H

#ifndef SANDBOX
#include <unistd.h>
static void lightwave_sandbox()
{
    if (geteuid() == 0 || getegid() == 0) {
        fprintf(stderr, "lightwave: refusing to run as superuser\n");
        abort();
    }
}
#else
void lightwave_sandbox();
#endif

#endif
