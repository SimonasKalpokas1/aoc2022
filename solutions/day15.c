#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_LINES 64
#define Y_AXIS 2000000
#define MAX_Y 4000000

typedef struct {
    int x, y;
} Coords;

typedef struct {
    Coords sensor;
    Coords beacon;
} Sensor;

int manhattanDistance(const Coords *a, const Coords *b) {
    return abs(a->x - b->x) + abs(a->y - b->y);
}

int coordsContains(const Coords *arr, const Coords *coords, int n) {
    for (int i = 0; i < n; ++i) {
        if (arr[i].x == coords->x && arr[i].y == coords->y) {
            return true;
        }
    }
    return false;
}

int areCoordsValid(const Coords* coords) {
    return coords->x <= coords->y;
}

int overlapIntersections(Coords *out, const Coords *b) {
    int overlap = out->y + 1 >= b->x && out->x - 1 <= b->y;
    if (overlap) {
        out->x = out->x > b->x ? b->x : out->x;
        out->y = out->y < b->y ? b->y : out->y;
    }
    return overlap;
}

int combineIntersections(Coords* intersections, int n) {
    int valid_count = n;
    for (int i = 0; i < n; ++i) {
        if (!areCoordsValid(&intersections[i])) {
            --valid_count;
            continue;
        }
        for (int j = i + 1; j < n; ++j) {
            if (areCoordsValid(&intersections[j]) && overlapIntersections(&intersections[j], &intersections[i])) {
                intersections[i] = (Coords) { 1, -1 };
                --valid_count;
                break;
            }
        }
    }
    return valid_count;
}

int calculate_part_1(Coords* intersections, int sensor_count, Coords* beacons, int beacon_count) {
    int ans = 0;
    for (int j = 0; j < sensor_count; ++j) {
        if (!areCoordsValid(&intersections[j])) {
            continue;
        }
        ans += intersections[j].y - intersections[j].x + 1;
        for (int k = 0; k < beacon_count; ++k) {
            if (beacons[k].y == Y_AXIS && beacons[k].x >= intersections[j].x && beacons[k].y <= intersections[j].y) {
                --ans;
            }
        }
    }
    return ans;
}

long long calculate_part_2(Coords* intersections, int sensor_count, int axis) {
    for (int j = 0; j < sensor_count; ++j) {
        if (areCoordsValid(&intersections[j])) {
            return (long long) (intersections[j].y > MAX_Y 
                ? (intersections[j].x - 1) 
                : (intersections[j].y + 1)) 
                * MAX_Y + axis;
        }
    }
    return -1;
}

Coords getIntersection(int y, Sensor *sensor) {
    int sensor_to_beacon = manhattanDistance(&sensor->sensor, &sensor->beacon);
    int sensor_to_slice = abs(sensor->sensor.y - y);
    if (sensor_to_slice > sensor_to_beacon) {
        return (Coords) { 1, -1 };
    }
    return (Coords) {
        sensor->sensor.x - (sensor_to_beacon - sensor_to_slice),
        sensor->sensor.x + (sensor_to_beacon - sensor_to_slice),
    };
}

int main(void) {
    FILE* file = fopen("../inputs/day15.txt", "r");

    Sensor sensors[MAX_LINES];
    Coords intersections[MAX_LINES];
    Coords beacons[MAX_LINES];

    int sensor_x, sensor_y, beacon_x, beacon_y;   
    int sensor_count = 0; 
    int beacon_count = 0;
    while (fscanf(file, "Sensor at x=%d, y=%d: closest beacon is at x=%d, y=%d\n", &sensor_x, &sensor_y, &beacon_x, &beacon_y) != EOF) {
        Coords beacon = (Coords) { beacon_x, beacon_y };
        sensors[sensor_count] = (Sensor) { { sensor_x, sensor_y }, beacon };

        if (!coordsContains(beacons, &beacon, beacon_count)) {
            beacons[beacon_count] = beacon;
            ++beacon_count;
        }
        ++sensor_count;
    }
    fclose(file);

    for (int i = 0; i <= MAX_Y; ++i) {
        for (int j = 0; j < sensor_count; ++j) {
            intersections[j] = getIntersection(i, &sensors[j]);
        }

        int valid_intersection_count = combineIntersections(intersections, sensor_count);

        if (i == Y_AXIS) {
            int part_1 = calculate_part_1(intersections, sensor_count, beacons, beacon_count);
            printf("Part 1: %d\n", part_1);
        }

        if (valid_intersection_count == 2) {
            long long part_2 = calculate_part_2(intersections, sensor_count, i);
            printf("Part 2: %lld\n", part_2);
        }
    }
    return 0;
}