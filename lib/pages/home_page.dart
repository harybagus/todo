import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/todo_button.dart';
import 'package:todo/components/todo_calendar.dart';
import 'package:todo/components/todo_day.dart';
import 'package:todo/components/todo_drawer_navigation.dart';
import 'package:todo/components/todo_logo.dart';
import 'package:todo/components/todo_month.dart';
import 'package:todo/components/todo_search.dart';
import 'package:todo/components/todo_snackbar.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/models/todo_and_category.dart';
import 'package:todo/pages/todo_page.dart';
import 'package:todo/services/category_service.dart';
import 'package:todo/services/todo_service.dart';

class HomePage extends StatefulWidget {
  final int id;
  final String? date;

  const HomePage({super.key, required this.id, this.date});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text editing controllers
  final TextEditingController searchController = TextEditingController();

  late String _keyword;

  TodoService? _todoService;
  CategoryService? _categoryService;

  List<TodoJoinCategory> _todo = <TodoJoinCategory>[];
  List<Category> _category = <Category>[];

  // current date
  DateTime today = DateTime.now();

  // on day selected
  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      calendarIconIsPressed = !calendarIconIsPressed;
    });

    getAllTodos();
  }

  // is pressed
  bool calendarIconIsPressed = false;
  int categoryIsPressed = 0;

  // get all todos
  getAllTodos() async {
    _todoService = TodoService();
    _todo = <TodoJoinCategory>[];

    dynamic todos;

    if (searchController.text.isNotEmpty && categoryIsPressed != 0) {
      todos = await _todoService!.readTodoByTitleAndCategoryId(
        widget.id,
        today.toString().split(' ')[0],
        _keyword,
        categoryIsPressed,
      );
    } else if (searchController.text.isNotEmpty) {
      todos = await _todoService!.readTodoByTitle(
        widget.id,
        today.toString().split(' ')[0],
        _keyword,
      );
    } else if (categoryIsPressed == 0) {
      todos = await _todoService!.readTodoByJoiningCategory(
        widget.id,
        today.toString().split(' ')[0],
      );
    } else {
      todos = await _todoService!.readTodoByCategoryId(
        widget.id,
        today.toString().split(' ')[0],
        categoryIsPressed,
      );
    }

    todos.forEach((todo) {
      setState(() {
        var model = TodoJoinCategory();

        model.id = todo['id'];
        model.accountId = todo['accountId'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.categoryId = todo['categoryId'];
        model.category = todo['category'];
        model.color = todo['color'];
        model.date = todo['date'];
        model.status = todo['status'];

        _todo.add(model);
      });
    });
  }

  // get all categories
  getAllCategories() async {
    _categoryService = CategoryService();
    _category = <Category>[];

    var categories = await _categoryService!.readCategoriesByAccountId(
      widget.id,
    );

    categories.forEach((category) {
      setState(() {
        var model = Category();

        model.id = category['id'];
        model.accountId = category['accountId'];
        model.category = category['category'];
        model.color = category['color'];

        _category.add(model);
      });
    });
  }

  // update status
  updateStatus(
    int? id,
    int? accountId,
    String? title,
    String? description,
    int? categoryId,
    String? date,
    String? status,
  ) async {
    _todoService = TodoService();
    var todo = Todo();

    if (date != DateTime.now().toString().split(' ')[0]) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        20,
        'Tidak bisa mengubah status',
      ));

      return;
    }

    todo.id = id;
    todo.accountId = accountId;
    todo.title = title;
    todo.description = description;
    todo.categoryId = categoryId;
    todo.date = date;
    todo.status = status == 'unfinished' ? 'finished' : 'unfinished';

    var updateStatus = await _todoService!.updateTodo(todo);

    // successfully changed status
    if (updateStatus > 0) {
      if (mounted) {
        // success message
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.green,
          20,
          'Berhasil mengubah status',
        ));
      }

      return;
    }
  }

  // delete todo
  deleteTodo(int id, String title) async {
    _todoService = TodoService();

    var deleteTodo = await _todoService!.deleteTodo(id);

    // successfully deleted todo
    if (deleteTodo > 0) {
      if (mounted) {
        // success message
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.green,
          20,
          'Berhasil menghapus tugas \'$title\'',
        ));
      }

      return;
    }
  }

  @override
  void initState() {
    super.initState();

    // check whether the date is null or not
    if (widget.date != null) {
      today = DateTime.parse(widget.date.toString());
    }

    // call some function
    getAllTodos();
    getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const TodoLogo(fontSize: 23),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                calendarIconIsPressed = !calendarIconIsPressed;
              });
            },
            icon: Icon(calendarIconIsPressed
                ? Icons.calendar_today_outlined
                : Icons.calendar_month_outlined),
          )
        ],
      ),
      drawer: TodoDrawerNavigation(id: widget.id),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // search
              TodoSearch(
                onChanged: (value) {
                  _keyword = value;
                  getAllTodos();
                },
                controller: searchController,
                text: 'Cari tugas',
              ),

              const SizedBox(height: 20),

              // day & date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // day
                  Text(
                    day(today),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // date
                  Text(
                    '${today.day} ${month(today)} ${today.year}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),

              // calendar
              if (calendarIconIsPressed)
                TodoCalendar(
                    focusedDay: today,
                    firstDay: DateTime.utc(2000),
                    onDaySelected: onDaySelected)
              else
                const SizedBox(height: 0),

              const SizedBox(height: 20),

              // categories
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    'Kategori',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // categories
                  if (_category.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 85,
                        padding: const EdgeInsets.only(right: 20),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _category.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (categoryIsPressed == 0) {
                                    categoryIsPressed =
                                        _category[index].id!.toInt();
                                  } else if (categoryIsPressed != 0 &&
                                      categoryIsPressed ==
                                          _category[index].id) {
                                    categoryIsPressed = 0;
                                  } else {
                                    categoryIsPressed =
                                        _category[index].id!.toInt();
                                  }
                                });

                                getAllTodos();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  border: categoryIsPressed ==
                                          _category[index].id
                                      ? Border.all(
                                          width: 1.5,
                                          color: Color(
                                              _category[index].color!.toInt()),
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // icon
                                    Icon(
                                      Icons.linear_scale_outlined,
                                      color: Color(
                                          _category[index].color!.toInt()),
                                    ),

                                    // category
                                    Text(
                                      _category[index].category.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(
                                            _category[index].color!.toInt()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Column(
                        children: [
                          // icon
                          const Icon(
                            Icons.category_outlined,
                            size: 40,
                          ),

                          const SizedBox(height: 5),

                          // text
                          Text(
                            'Tidak ada kategori',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // todos
              Column(
                children: [
                  // row
                  Row(
                    children: [
                      // title
                      Text(
                        'Tugas',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      // add button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodoPage(
                                id: widget.id,
                                date: today.toString().split(' ')[0],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 35,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: GoogleFonts.poppins(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // todos
                  if (_todo.isNotEmpty)
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      child: ListView.builder(
                        itemCount: _todo.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              todoDetail(
                                _todo[index].id!.toInt(),
                                _todo[index].accountId!.toInt(),
                                _todo[index].title.toString(),
                                _todo[index].description.toString(),
                                _todo[index].categoryId!.toInt(),
                                _todo[index].category.toString(),
                                _todo[index].color!.toInt(),
                                _todo[index].date.toString(),
                                _todo[index].status.toString(),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12.5),
                              color: Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 15,
                                  right: 7.5,
                                  bottom: 15,
                                  left: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // category
                                    Text(
                                      _todo[index].category.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color(_todo[index].color!.toInt()),
                                      ),
                                    ),

                                    // row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // status
                                        Text(
                                          "|",
                                          style: GoogleFonts.poppins(
                                            fontSize: 45,
                                            fontWeight: FontWeight.w200,
                                            color: Color(
                                                _todo[index].color!.toInt()),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        // todo and description
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // todo
                                              Text(
                                                _todo[index].title.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              // description
                                              Text(
                                                _todo[index]
                                                    .description
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // status
                                        IconButton(
                                          onPressed: () {
                                            updateStatus(
                                              _todo[index].id,
                                              _todo[index].accountId,
                                              _todo[index].title,
                                              _todo[index].description,
                                              _todo[index].categoryId,
                                              _todo[index].date,
                                              _todo[index].status,
                                            );

                                            getAllTodos();
                                          },
                                          icon: Icon(
                                            _todo[index].status.toString() ==
                                                    'unfinished'
                                                ? Icons.check_box_outline_blank
                                                : Icons.check_box_outlined,
                                            size: 30,
                                            color: Color(
                                              _todo[index].color!.toInt(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Center(
                      heightFactor: 3,
                      child: Column(
                        children: [
                          // image
                          if (Theme.of(context).colorScheme.background ==
                              Colors.black)
                            Image.asset('lib/images/notask-white.png',
                                width: 100)
                          else
                            Image.asset('lib/images/notask-black.png',
                                width: 100),

                          const SizedBox(height: 10),

                          // text
                          Text(
                            'Tidak ada tugas',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> todoDetail(
    int id,
    int accountId,
    String title,
    String description,
    int categoryId,
    String category,
    int color,
    String date,
    String status,
  ) {
    return showDialog(
      context: context,
      builder: (builder) => AlertDialog(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            // title
            Text(
              'Detail Tugas',
              style: GoogleFonts.poppins(),
            ),

            const Spacer(),

            if (date == DateTime.now().toString().split(' ')[0] ||
                DateTime.now().isBefore(DateTime.parse(date)))
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => TodoPage(
                            id: widget.id,
                            todoId: id,
                            categoryId: categoryId,
                            title: title,
                            description: description,
                            date: date,
                            status: status,
                          )),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.yellow.shade700,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              )
            else
              const SizedBox(),

            const SizedBox(width: 10),

            // delete icon
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (builder) => AlertDialog(
                    elevation: 0,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: Text(
                      'Yakin ingin menghapus tugas \'$title\'',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                      ),
                    ),
                    content: Row(
                      children: [
                        // cancel button
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 3.15,
                          child: TodoButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Theme.of(context).colorScheme.primary,
                            text: 'Batal',
                          ),
                        ),

                        const Spacer(),

                        // save button
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 3.15,
                          child: TodoButton(
                            onPressed: () {
                              deleteTodo(id, title);

                              Navigator.pop(context);
                              Navigator.pop(context);

                              getAllTodos();
                            },
                            color: Colors.red,
                            text: 'Hapus',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                child: Icon(
                  Icons.delete_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // category
              Text(
                category,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(color),
                ),
              ),

              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(color)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // title
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // description
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // day & date
                    Row(
                      children: [
                        // day
                        Text(
                          '${day(DateTime.parse(date))}, ',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            // color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),

                        // date
                        Text(
                          '${DateTime.parse(date).day} ${month(DateTime.parse(date))} ${DateTime.parse(date).year}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            // color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
