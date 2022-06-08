int convertToMin(int time) {
  if (time == 1) {
    return 10;
  } else if (time == 2) {
    return 30;
  } else if (time == 3) {
    return 1;
  } else if (time == 4) {
    return 2;
  } else if (time == 5) {
    return 4;
  } else if (time == 6) {
    return 6;
  } else {
    return 0;
  }
}

int convertToValue(int time) {
  if (time == 10) {
    return 1;
  } else if (time == 30) {
    return 2;
  } else if (time == 1) {
    return 3;
  } else if (time == 2) {
    return 4;
  } else if (time == 4) {
    return 5;
  } else if (time == 6) {
    return 6;
  } else {
    return 0;
  }
}
