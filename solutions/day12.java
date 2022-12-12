import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Scanner;

public class day12 {
    static List<String> grid = new ArrayList<>();
    static int height = -1;
    static int width = -1;

    public static void main(String[] args) {

        Point start = new Point(), end = new Point();
        try {
            File file = new File("../inputs/day12.txt");

            Scanner scanner = new Scanner(file);
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                int ind;
                if ((ind = line.indexOf("S")) != -1) {
                    start.x = ind;
                    start.y = grid.size();
                    line = line.replace("S", "a");
                }
                if ((ind = line.indexOf("E")) != -1) {
                    end.x = ind;
                    end.y = grid.size();
                    line = line.replace("E", "z");
                }
                grid.add(line);
            }
            scanner.close();
        } catch (FileNotFoundException e) {
            System.out.println("No file :'(");
            return;
        }

        height = grid.size();
        width = grid.get(0).length();

        System.out.println("Part 1: " + 
                calculate(start, end, new Part() {
                    @Override
                    public Boolean canVisit(Point from, Point to) {
                        return grid.get(to.y).charAt(to.x) - grid.get(from.y).charAt(from.x) < 2;
                    }
                    @Override
                    public Boolean isDone(Point point) {
                        return point.y == end.y && point.x == end.x;
                    }
                }));
        System.out.println("Part 2: " + 
                calculate(end, start, new Part() {
                    @Override
                    public Boolean canVisit (Point from, Point to) {
                        return grid.get(from.y).charAt(from.x) - grid.get(to.y).charAt(to.x) < 2;
                    }
                    @Override
                    public Boolean isDone(Point point) {
                        return grid.get(point.y).charAt(point.x) == 'a';
                    }
                }));
    }

    public static int calculate(Point start, Point end, Part part) {
        Queue<Point> points = new LinkedList<>();

        Boolean visited[][] = new Boolean[height][width];
        for (int i = 0; i < height; i++) {
            Arrays.fill(visited[i], false);
        }

        visited[start.y][start.x] = true;
        points.add(start);

        int neighbors[][] = { { 0, 1 }, { 1, 0 }, { 0, -1 }, { -1, 0 } };
        while (points.size() != 0) {
            var point = points.remove();

            for (int i = 0; i < 4; i++) {
                var newPoint = new Point(point.x + neighbors[i][0], point.y + neighbors[i][1], point.distance + 1);
                if (newPoint.x < width && newPoint.x >= 0
                        && newPoint.y >= 0 && newPoint.y < height
                        && !visited[newPoint.y][newPoint.x]
                        && part.canVisit(point, newPoint)) {

                    if (part.isDone(newPoint)) {
                        return newPoint.distance;
                    }

                    visited[newPoint.y][newPoint.x] = true;
                    points.add(newPoint);
                }
            }
        }
        return -1;
    }
}

interface Part {
    Boolean canVisit(Point from, Point to);
    Boolean isDone(Point point);
}

class Point {
    int x, y;
    int distance;

    public Point() {
    }

    public Point(int x, int y, int distance) {
        this.x = x;
        this.y = y;
        this.distance = distance;
    }
}