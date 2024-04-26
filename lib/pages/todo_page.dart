import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/components/todo_button.dart';
import 'package:todo/components/todo_calendar.dart';
import 'package:todo/components/todo_color.dart';
import 'package:todo/components/todo_day.dart';
import 'package:todo/components/todo_month.dart';
import 'package:todo/components/todo_snackbar.dart';
import 'package:todo/components/todo_textformfield.dart';
import 'package:todo/models/category.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/pages/home_page.dart';
import 'package:todo/services/category_service.dart';
import 'package:todo/services/todo_service.dart';

class TodoPage extends StatefulWidget {
  final int id;
  final int? todoId;
  final int? categoryId;
  final String? title;
  final String? description;
  final String? date;
  final String? status;

  const TodoPage({
    super.key,
    required this.id,
    this.todoId,
    this.categoryId,
    this.title,
    this.description,
    this.date,
    this.status,
  });

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // text editing controller
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  TodoService? _todoService;
  CategoryService? _categoryService;

  List<Category> _category = <Category>[];

  // current date
  DateTime today = DateTime.now();

  // on day selected
  void onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
      Navigator.pop(context);
    });
  }

  // get all categories
  getAllCategories() async {
    _categoryService = CategoryService();
    _category = <Category>[];

    var categories =
        await _categoryService!.readCategoriesByAccountId(widget.id);

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

  // selected
  int selectedColor = 0;
  int selectedCategory = 0;

  // is pressed
  bool addCategoryButtonIsPressed = true;

  // create category
  createCategory() async {
    _categoryService = CategoryService();
    var category = Category();

    // if all are empty
    if (categoryController.text.isEmpty && selectedColor == 0) {
      Navigator.pop(context);

      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        105,
        'Kategori harus diisi dan pilih salah satu warna',
      ));

      return;
    }

    // is one of them are empty
    if (categoryController.text.isEmpty) {
      Navigator.pop(context);

      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        105,
        'Kategori harus diisi',
      ));

      return;
    } else if (selectedColor == 0) {
      Navigator.pop(context);

      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        105,
        'Pilih salah satu warna',
      ));

      return;
    }

    category.accountId = widget.id;
    category.category = categoryController.text;
    category.color = selectedColor;

    var createCategory = await _categoryService!.createCategory(category);

    // successfully created category
    if (createCategory > 0) {
      categoryController.clear();
      setState(() {
        selectedColor = 0;
      });

      if (mounted) {
        Navigator.pop(context);

        // success message
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.green,
          105,
          'Berhasil membuat kategori',
        ));
      }

      return;
    }
  }

  // update category
  updateCategory(id, text, color) async {
    _categoryService = CategoryService();
    var category = Category();

    String categoryText;

    if (categoryController.text.isEmpty && selectedColor == color) {
      Navigator.pop(context);
      return;
    } else if (selectedColor != color) {
      categoryText = text;
    } else {
      categoryText = categoryController.text;
    }

    category.id = id;
    category.accountId = widget.id;
    category.category = categoryText;
    category.color = selectedColor;

    var updateCategory = await _categoryService!.updateCategory(category);

    // successfully changed category
    if (updateCategory > 0) {
      categoryController.clear();
      setState(() {
        selectedColor = 0;
      });

      if (mounted) {
        Navigator.pop(context);

        // success message
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.green,
          105,
          'Berhasil mengubah kategori',
        ));
      }

      return;
    }
  }

  // create todo
  createTodo() async {
    _todoService = TodoService();
    var todo = Todo();

    // if all are empty
    if (titleController.text.isEmpty &&
        descriptionController.text.isEmpty &&
        selectedCategory == 0) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        105,
        'Judul dan deskripsi harus diisi serta pilih salah satu kategori',
      ));

      return;
    }

    // is one of them are empty
    if (titleController.text.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        105,
        'Judul harus diisi',
      ));

      return;
    } else if (descriptionController.text.isEmpty) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        105,
        'Deskripsi harus diisi',
      ));

      return;
    } else if (selectedCategory == 0) {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
        Colors.red,
        105,
        'Pilih salah satu kategori',
      ));

      return;
    }

    todo.accountId = widget.id;
    todo.title = titleController.text;
    todo.description = descriptionController.text;
    todo.categoryId = selectedCategory;
    todo.date = today.toString().split(' ')[0];
    todo.status = 'unfinished';

    var createTodo = await _todoService!.createTodo(todo);

    // successfully created todo
    if (createTodo > 0) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              id: widget.id,
              date: today.toString().split(' ')[0],
            ),
          ),
        );

        // success message
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.green,
          20,
          'Berhasil membuat tugas',
        ));
      }

      return;
    }
  }

  // update todo
  updateTodo() async {
    _todoService = TodoService();
    var todo = Todo();

    dynamic title;
    dynamic description;

    // if all are empty or the same as the old one
    if (titleController.text.isEmpty &&
        descriptionController.text.isEmpty &&
        selectedCategory == widget.categoryId &&
        today.toString().split(' ')[0] == widget.date) {
      Navigator.pop(context);
      return;
    }

    if (titleController.text.isNotEmpty) {
      title = titleController.text;
    } else {
      title = widget.title;
    }

    if (descriptionController.text.isNotEmpty) {
      description = descriptionController.text;
    } else {
      description = widget.description;
    }

    todo.id = widget.todoId;
    todo.accountId = widget.id;
    todo.title = title;
    todo.description = description;
    todo.categoryId = selectedCategory;
    todo.date = today.toString().split(' ')[0];
    todo.status = widget.status;

    var updateTodo = await _todoService!.updateTodo(todo);

    if (updateTodo > 0) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              id: widget.id,
              date: today.toString().split(' ')[0],
            ),
          ),
        );

        // success message
        ScaffoldMessenger.of(context).showSnackBar(todoSnackBar(
          Colors.green,
          20,
          'Berhasil mengubah tugas',
        ));
      }

      return;
    }
  }

  @override
  void initState() {
    super.initState();

    // check whether the date and the category id are null or not
    if (widget.date != null && widget.categoryId != null) {
      today = DateTime.parse(widget.date.toString());
      selectedCategory = widget.categoryId!.toInt();
    }

    // call the function
    getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  id: widget.id,
                  date: widget.date,
                ),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('Buat Tugas', style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height / 1.214,
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // todo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    'Tugas',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // todo title
                  TodoTextFormField(
                    controller: titleController,
                    hintText: widget.title == null
                        ? 'Judul'
                        : widget.title.toString(),
                    prefixIcon: const Icon(Icons.edit_outlined),
                    maxLines: 1,
                  ),

                  const SizedBox(height: 15),

                  // description
                  TodoTextFormField(
                    controller: descriptionController,
                    hintText: widget.description == null
                        ? 'Deskripsi'
                        : widget.description.toString(),
                    prefixIcon: const Icon(Icons.edit_note_outlined),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 15),

                  // date
                  Row(
                    children: [
                      // date picker
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (builder) => AlertDialog(
                              elevation: 0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: Center(
                                child: Text(
                                  'Pilih Tanggal',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              content: SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height:
                                    MediaQuery.sizeOf(context).height / 2.575,
                                child: TodoCalendar(
                                  focusedDay: today,
                                  firstDay: DateTime.now(),
                                  onDaySelected: onDaySelected,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 125,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 18),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              // icon
                              const Icon(Icons.edit_calendar_outlined),

                              const SizedBox(width: 10),

                              // title
                              Text(
                                'Tanggal',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      // shows the date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day(today),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${today.day} ${month(today)} ${today.year}',
                            style: GoogleFonts.poppins(fontSize: 17),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 45),

              // category
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

                  const SizedBox(height: 10),

                  // categories
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // add category button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              addCategoryButtonIsPressed = true;
                            });

                            showCategoryDialog();
                          },
                          child: Container(
                            width: 95,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '+',
                                style: GoogleFonts.poppins(fontSize: 30),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        SizedBox(
                          width: MediaQuery.sizeOf(context).width +
                              _category.length * 75,
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _category.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory =
                                        _category[index].id!.toInt();
                                  });
                                },
                                onLongPress: () {
                                  setState(() {
                                    addCategoryButtonIsPressed = false;
                                    selectedColor =
                                        _category[index].color!.toInt();
                                  });

                                  showCategoryDialog(
                                    id: _category[index].id,
                                    text: _category[index].category,
                                    color: _category[index].color,
                                  );
                                },
                                child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color:
                                        Color(_category[index].color!.toInt()),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        _category[index].category.toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      if (selectedCategory ==
                                          _category[index].id)
                                        const Row(
                                          children: [
                                            SizedBox(width: 10),
                                            Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          ],
                                        )
                                      else
                                        const SizedBox(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              const Spacer(),

              // button
              Row(
                children: [
                  // cancel button
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2.35,
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
                    width: MediaQuery.sizeOf(context).width / 2.35,
                    child: TodoButton(
                      onPressed: () {
                        widget.todoId == null ? createTodo() : updateTodo();
                      },
                      color: Theme.of(context).colorScheme.primary,
                      text: widget.todoId == null ? 'Buat' : 'Simpan',
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

  Future<dynamic> showCategoryDialog({int? id, String? text, int? color}) {
    return showDialog(
      context: context,
      builder: (builder) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Center(
            child: Text(
              'Kategori',
              style: GoogleFonts.poppins(),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 290,
            child: Column(
              children: [
                // category
                TodoTextFormField(
                  controller: categoryController,
                  hintText: addCategoryButtonIsPressed ? 'Kategori' : '$text',
                  prefixIcon: const Icon(Icons.category_outlined),
                  maxLines: 1,
                ),

                const SizedBox(height: 15),

                // color
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Text(
                      'Pilih warna',
                      style: GoogleFonts.poppins(fontSize: 17),
                    ),

                    const SizedBox(height: 5),

                    // color
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFF00BCD4;
                            });
                          },
                          color: const Color(0xFF00BCD4),
                          child: selectedColor == 0xFF00BCD4
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFFAFB42B;
                            });
                          },
                          color: const Color(0xFFAFB42B),
                          child: selectedColor == 0xFFAFB42B
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFFFF9800;
                            });
                          },
                          color: const Color(0xFFFF9800),
                          child: selectedColor == 0xFFFF9800
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFFF44336;
                            });
                          },
                          color: const Color(0xFFF44336),
                          child: selectedColor == 0xFFF44336
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFFE91E63;
                            });
                          },
                          color: const Color(0xFFE91E63),
                          child: selectedColor == 0xFFE91E63
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // color
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFF2196F3;
                            });
                          },
                          color: const Color(0xFF2196F3),
                          child: selectedColor == 0xFF2196F3
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFF4CAF50;
                            });
                          },
                          color: const Color(0xFF4CAF50),
                          child: selectedColor == 0xFF4CAF50
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFFFFC107;
                            });
                          },
                          color: const Color(0xFFFFC107),
                          child: selectedColor == 0xFFFFC107
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFF795548;
                            });
                          },
                          color: const Color(0xFF795548),
                          child: selectedColor == 0xFF795548
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                        TodoColor(
                          onTap: () {
                            setState(() {
                              selectedColor = 0xFF9C27B0;
                            });
                          },
                          color: const Color(0xFF9C27B0),
                          child: selectedColor == 0xFF9C27B0
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // button
                Row(
                  children: [
                    // cancel button
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 3.15,
                      child: TodoButton(
                        onPressed: () {
                          categoryController.clear();
                          setState(() {
                            selectedColor = 0;
                          });
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
                          addCategoryButtonIsPressed
                              ? createCategory()
                              : updateCategory(id, text, color);
                          getAllCategories();
                        },
                        color: Theme.of(context).colorScheme.primary,
                        text: addCategoryButtonIsPressed ? 'Buat' : 'Simpan',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
