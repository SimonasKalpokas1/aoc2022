const std = @import("std");
const Allocator = std.mem.Allocator;

const i64Node = Node(i64);

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const numbers = try parseInput("../inputs/day20.txt");

    try stdout.print("Part 1: {d}\n", .{try part1(numbers)});
    try bw.flush();
    try stdout.print("Part 2: {d}\n", .{try part2(numbers)});
    try bw.flush();
}

fn part1(numbers: []i64) !i64 {
    const outputs = try toCircularLinkedList(numbers);
    const count = numbers.len;
    for (outputs[1]) |node| {
        applyMixStep(node, count);
    }
    return sumGroveCoordinates(outputs[0]);
}

fn part2(numbers: []i64) !i64 {
    const key: i64 = 811589153;
    const outputs = try toCircularLinkedList(numbers);
    const count = numbers.len;
    for (outputs[1]) |node| {
        node.data *= key;
    }

    for (0..10) |_| {
        for (outputs[1]) |node| {
            applyMixStep(node, count);
        }
    }
    return sumGroveCoordinates(outputs[0]);
}

fn applyMixStep(node: *i64Node, count: usize) void {
    var len: i64 = @intCast(count);
    var target: i64 = @mod(node.data, len-1);
    if (target == 0) {
        return;
    }
    node.remove();

    var to: *i64Node = node;
    for (0..@intCast(target)) |_| {
        to = to.next.?;
    }
    to.insertAfter(node);
}

fn sumGroveCoordinates(node: *i64Node) i64 {
    var current = node;
    while (current.data != 0) : (current = current.next.?) {}

    var sum: i64 = 0;
    for (0..3) |_| {
        for (0..1000) |_| {
            current = current.next.?;
        }
        sum += current.data;
    }
    return sum;
}

fn parseInput(filename: []const u8) ![]i64 {
    var file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    var numbers = try std.ArrayList(i64).initCapacity(std.heap.page_allocator, 5000);
    defer numbers.deinit();
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const number: i64 = try std.fmt.parseInt(i64, line, 10);
        try numbers.append(number);
    }
    return numbers.toOwnedSlice();
}

fn toCircularLinkedList(numbers: []i64) !std.meta.Tuple(&.{ *i64Node, []*i64Node }) {
    var arrayList = try std.ArrayList(*i64Node).initCapacity(std.heap.page_allocator, 5000);
    defer arrayList.deinit();
    var head = try i64Node.create(numbers[0], std.heap.page_allocator);
    try arrayList.append(head);
    var current = head;

    for (numbers[1..]) |number| {
        var next = try i64Node.create(number, std.heap.page_allocator);
        try arrayList.append(next); 
        current.insertAfter(next);
        current = next;
    }

    // Making the doubly linked list circular
    current.next = head;
    head.previous = current;

    return .{head, try arrayList.toOwnedSlice()};
}

fn Node(comptime T: type) type {
    return struct {
        const Self = @This();

        next: ?*Node(T) = null,
        previous: ?*Node(T) = null,
        data: T,

        pub fn insertAfter(node: *Self, new_node: *Node(T)) void {
            new_node.next = node.next;
            if (node.next != null) {
                node.next.?.previous = new_node;
            }
            node.next = new_node;
            new_node.previous = node;
        }

        pub fn remove(node: *Self) void {
            if (node.next != null) {
                node.next.?.previous = node.previous;
            }
            if (node.previous != null) {
                node.previous.?.next = node.next;
            }
        }

        pub fn create(data: T, alloc: Allocator) !*Node(T) {
            const new = try alloc.create(Node(T));
            new.data = data;
            new.next = null;
            new.previous = null;
            return new;
        }

    };
}

